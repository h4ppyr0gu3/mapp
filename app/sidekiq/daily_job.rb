# frozen_string_literal: true

class DailyJob
  include Sidekiq::Job
  sidekiq_options retry: 2

  def perform
    files = Dir["#{download_dir}/*"]
    files.each do |file|
      FileUtils.rm_rf(file)
    end
  end

  private

  def download_dir
    Rails.root.join("tmp", "downloads")
  end
end
