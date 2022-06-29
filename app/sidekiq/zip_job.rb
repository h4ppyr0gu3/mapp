# frozen_string_literal: true

class ZipJob
  include Sidekiq::Job

  attr_reader :params, :context

  def perform(params)
    params = JSON.parse(params).deep_symbolize_keys
    set_context(params)
    files = Downloads::UseCases::All.new(params:, context:).call
    filepaths = create_temp_dir(files)
    create_zip_file(filepaths)
    Notification.create!(
      user_id: current_user.id,
      text: "Your download is ready, <a href='http://localhost:3000/mapp_#{current_user.email}.zip'>here you go</a>",
      read: false
    )
  end

  private

  def set_context(params)
    @params = params
    @context = params[:context]
  end

  def current_user
    @current_user ||= User.find(context[:user][:id])
  end

  def create_temp_dir(files)
    temp_folder = File.join(Dir.tmpdir, "mapp_#{current_user.email}")
    FileUtils.mkdir_p(temp_folder) unless Dir.exist?(temp_folder)

    files.map do |song|
      filename = song.last.to_s
      filepath = File.join temp_folder, filename
      File.binwrite(filepath, song.first.download)
      filepath
    end
  end

  # rubocop:disable Metrics/MethodLength
  def create_zip_file(filepaths)
    require "zip"
    # security vulnerability being able to guess email addresses
    zip_file = Rails.root.join("public", "mapp_#{current_user.email}.zip")
    FileUtils.rm(zip_file) if File.exist?(zip_file)
    begin
      ::Zip::File.open(zip_file, create: true) do |zipfile|
        filepaths.each do |file|
          filename = File.basename file
          zipfile.add(filename, file)
        end
      end
      zip_file
    ensure
      filepaths.each { |filepath| FileUtils.rm(filepath) }
    end
  end
  # rubocop:enable Metrics/MethodLength
end
