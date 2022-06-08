# frozen_string_literal: true

require 'down'

class DownloadJob
  include Sidekiq::Job

  def perform(params)
    params = params.symbolize_keys
    dir = Rails.root.join('tmp', 'downloads')
    system("#{Rails.root.join('lib', 'scripts', 'download.sh')} #{dir} #{params[:video_id]}")
    song = Song.create(title: params[:title], artist: params[:channel], video_id: params[:video_id], image_url: params[:image_url])
    return unless song.save

    attach_image(song, params[:image_url], params[:video_id])
    attach_mp3(song, params[:video_id])
    ::UserSong.create(user_id: params[:user_id], song_id: song.id)
  end

  def attach_image(song, image_url, video_id)
    unless song.image.attached? || image_url.nil?
      image = Rails.root.join('tmp', 'downloads', "#{video_id}.jpg")
      ::Down.download(image_url, destination: image)
      song.image.attach(
        io: File.open(image),
        filename: "#{image_url}.jpg"
      )
      system("rm #{image}") if song.image.attached?
    end
  end

  def attach_mp3(song, video_id)
    file_path = Rails.root.join('tmp', 'downloads', "#{video_id}.mp3")
    if File.exist?(file_path)
      song.mp3.attach(
        io: File.open(file_path),
        filename: "#{video_id}.mp3"
      )
    end
    system("rm #{file_path}") if song.mp3.attached?
  end
end
