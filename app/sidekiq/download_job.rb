require "open-uri"

class DownloadJob
  include Sidekiq::Job

  def perform(video_id, image_url, title, channel, user_id)
    dir = Rails.root.join("tmp", "downloads")
    system("#{Rails.root.join("lib", "scripts", "download.sh")} #{dir} #{video_id}")
    song = Song.create(title: title, artist: channel)
    if song.save?
      attach_image(song, image_url)
      attach_mp3(song, video_id)
      UserSongs.create(user_id: user_id, song_id: song.id)
    end
  end

  def attach_image(song, image_url)
    image = open(image_url)
    song.image.attach(
      io: image,
      filename: "#{image_url}.jpg"
    )
  end

  def attach_mp3(song, video_id)
    file_path = Rails.root.join("tmp", "downloads", "#{video_id}.mp3")
    if File.exist?(file_path)
      song.mp3.attach(
        io: File.open(file_path),
        filename: "#{video_id}.mp3"
      )
    end
  end
end
