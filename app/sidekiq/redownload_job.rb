# frozen_string_literal: true

require "down"

class RedownloadJob
  include Sidekiq::Job

  def perform(params)
    params = JSON.parse(params).symbolize_keys
    dir = Rails.root.join("tmp", "downloads")
    system("#{Rails.root.join('lib', 'scripts', 'download.sh')} #{dir} #{params[:video_id]}")
    song = Song.find_by(video_id: params[:video_id])
    song.update(updated: 1)
    return if song.nil?

    attach_items(params, song)
  end

  private

  def attach_items(_params, song)
    attach_image(song, song.image_url, song.video_id)
    attach_mp3(song, song.video_id)
  end

  def attach_image(song, image_url, video_id)
    image_path = Rails.root.join("tmp", "downloads", "#{video_id}.jpg")
    begin
      ::Down.download(image_url, destination: image_path)
      song.image.purge
      song.image.attach(io: File.open(image_path), filename: "#{image_url}.jpg")
      system("rm #{image_path}") if song.image.attached?
    rescue StandardError
      attach_generic_image(song)
    end
  end

  def attach_generic_image(song)
    song.image.attach(
      io: File.open(Rails.root.join("app", "assets", "images", "generic_mp3.jpg")),
      filename: "generic_#{song.video_id}.jpg"
    )
  end

  def attach_mp3(song, video_id)
    file_path = Rails.root.join("tmp", "downloads", "#{video_id}.mp3")
    if File.exist?(file_path)
      song.mp3.purge
      song.mp3.attach(
        io: File.open(file_path),
        filename: "#{video_id}.mp3"
      )
    end
    system("rm #{file_path}") if song.mp3.attached?
  end
end
