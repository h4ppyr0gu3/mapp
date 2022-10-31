# frozen_string_literal: true

require "securerandom"

class ZipJob
  include Sidekiq::Job

  attr_reader :params, :context

  def perform(params)
    params = JSON.parse(params).deep_symbolize_keys
    set_context(params)
    files = Downloads::UseCases::All.new(params:, context:).call
    if files.empty?
      notify_no_files
      return
    end
    filepaths = create_temp_dir(files)
    random_id = SecureRandom.hex(4)
    create_zip_file(filepaths, random_id)
    Notification.create!(
      user_id: current_user.id,
      text: "Your download is ready, <a href='#{ENV.fetch('API_URL', nil)}/mapp_#{random_id}.zip'>here you go</a>",
      read: false
    )
  end

  private

  def notify_no_files
    Notification.create!(
      user_id: current_user.id,
      text: "All songs have been downloaded, wipe device?",
      read: false
    )
  end

  def set_context(params)
    @params = params
    @context = params[:context]
  end

  def current_user
    @current_user ||= User.find(context[:user][:id])
  end

  def create_temp_dir(files)
    temp_folder = File.join(Dir.tmpdir, "mapp_#{current_user.email}")
    FileUtils.rm_rf(temp_folder) if File.exist?(temp_folder)
    FileUtils.mkdir_p(temp_folder) unless Dir.exist?(temp_folder)

    files.map do |song|
      filename = song.last.to_s
      filepath = File.join temp_folder, filename
      File.binwrite(filepath, song.first.download)
      filepath
    rescue ActiveStorage::FileNotFoundError
      Rails.logger.info("Failed to find song: #{song}")
    end
  end

  # rubocop:disable Metrics/MethodLength
  def create_zip_file(filepaths, random_id)
    require "zip"
    # security vulnerability being able to guess email addresses
    zip_file = Rails.root.join("public", "mapp_#{random_id}.zip")
    FileUtils.rm(zip_file) if File.exist?(zip_file)
    begin
      ::Zip::File.open(zip_file, create: true) do |zipfile|
        filepaths.each do |file|
          next if file.is_a? Integer

          begin
            filename = File.basename file
            zipfile.add(filename, file)
          rescue ActiveStorage::FileNotFoundError
            Rails.logger.info("Failed to find file: #{file}")
          end
        end
      end
      zip_file
    ensure
      filepaths.each do |filepath|
        next if filepath.is_a? Integer

        FileUtils.rm(filepath)
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
end
