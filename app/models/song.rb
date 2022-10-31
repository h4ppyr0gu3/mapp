# frozen_string_literal: true

class Song < ApplicationRecord
  has_one_attached :image
  has_one_attached :mp3
  has_many :user_songs, dependent: :destroy
  has_many :users, through: :user_songs
  has_many :device_songs, dependent: :destroy
  has_many :devices, through: :device_songs
  validates :title, presence: true
  validates :video_id, presence: true, uniqueness: true

  enum updated: { vanilla: 0, by_the_user: 1, written: 2 }

  def update_metadata
    create_local_copies
    system(ffmpeg_command)
    update_attached
    clean_on_success
  end

  def redownload_mp3
    # rerun Down command
  end

  def redownload_image
    # rerun ytdlp
  end

  private

  def clean_on_success
    return unless mp3.attached?

    system("rm #{new_song_file_path} #{song_file_path} #{image_file_path}")
    update(updated: :written)
  end

  def song_file_path
    Rails.root.join("tmp", "downloads", "#{video_id}.mp3").to_s
  end

  def new_song_file_path
    Rails.root.join("tmp", "downloads", "new_#{video_id}.mp3").to_s
  end

  def image_file_path
    Rails.root.join("tmp", "downloads", "#{video_id}.jpg").to_s
  end

  def ffmpeg_command
    "ffmpeg -i #{song_file_path} -i #{image_file_path} \
    -map 0:a -map 1:0 -id3v2_version 4 \
    #{create_ffmpeg_metadata_string} #{new_song_file_path}"
  end

  def create_local_copies
    File.binwrite(song_file_path, mp3.download)
    File.binwrite(image_file_path, image.download)
  end

  def update_attached
    mp3.purge if mp3.attached?
    mp3.attach(
      io: File.open(new_song_file_path),
      filename: "#{title}.mp3"
    )
  end

  # rubocop:disable Metrics:AbcComplexity
  def create_ffmpeg_metadata_string
    # metadata << "-metadata title='#{song.title}'" if song.title != nil
    # metadata << "-metadata album_artist='London Symphony'"
    # metadata << "-metadata track='#{song.track_no}'"
    metadata = []
    metadata << "-metadata title='#{title}'" unless title.nil?
    metadata << "-metadata artist='#{artist}'" unless artist.nil?
    metadata << "-metadata album='#{album}'" unless album.nil?
    metadata << "-metadata date='#{year}'" unless year.nil?
    metadata << "-metadata genre='#{genre}'" unless genre.nil?
    metadata.join(" ")
  end
  # rubocop:enable Metrics:AbcComplexity
end
