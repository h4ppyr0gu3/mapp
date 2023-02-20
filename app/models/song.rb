# frozen_string_literal: true

require "down"

class Song < ApplicationRecord
  has_one_attached :image
  has_one_attached :mp3
  has_many :user_songs, dependent: :destroy
  has_many :users, through: :user_songs
  has_many :device_songs, dependent: :destroy
  has_many :devices, through: :device_songs
  validates :title, presence: true
  validates :video_id, presence: true, uniqueness: true

  enum updated: { vanilla: 0, by_the_user: 1, written: 2, error: 3 }

  # should be used ASYNC
  def update_metadata
    clean_download_dir
    create_local_copies
    if system(ffmpeg_command)
      update_attached
      update(updated: :written)
    else
      flag_error
    end
  end

  # should be used ASYNC
  def download_mp3
    clean_download_dir
    if system("#{download_script} #{download_dir} #{video_id}")
      mp3.purge if mp3.attached?
      mp3.attach(
        io: File.open(song_file_path),
        filename: "#{video_id}.mp3"
      )
    else
      flag_error
    end
  end

  # should be used ASYNC
  def download_image
    clean_download_dir
    ::Down.download(image_url, destination: image_file_path)
    image.purge if image.attached?
    image.attach(
      io: File.open(image_file_path),
      filename: "#{video_id}.jpg"
    )
  end

  # should be used ASYNC
  def redownload_mp3
    download_mp3
    update(updated: :by_the_user)
  end

  # should be used ASYNC
  def redownload_image
    download_image
    update(updated: :by_the_user)
  end

  def flag_error
    update(updated: :error)
  end

  def image_url
    "https://img.youtube.com/vi/#{video_id}/hqdefault.jpg"
  end

  private

  def clean_download_dir
    FileUtils.rm_rf(song_file_path)
    FileUtils.rm_rf(new_song_file_path)
    FileUtils.rm_rf(image_file_path)
  end

  def download_script
    Rails.root.join("lib", "scripts", "download.sh")
  end

  def download_dir
    Rails.root.join("tmp", "downloads")
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
      filename: "#{artist}_#{title}.mp3"
    )
  end

  # rubocop:disable Metrics/AbcSize, Style/StringLiteralsInInterpolation
  def create_ffmpeg_metadata_string
    # metadata << "-metadata title='#{song.title}'" if song.title != nil
    # metadata << "-metadata album_artist='London Symphony'"
    # metadata << "-metadata track='#{song.track_no}'"
    metadata = []
    metadata << "-metadata title=\"#{title.gsub("\"", "\\\"")}\"" unless title.nil?
    metadata << "-metadata artist=\"#{artist.gsub("\"", "\\\"")}\"" unless artist.nil?
    metadata << "-metadata album=\"#{album.gsub("\"", "\\\"")}\"" unless album.nil?
    metadata << "-metadata date=\"#{year.gsub("\"", "\\\"")}\"" unless year.nil?
    metadata << "-metadata genre=\"#{genre.gsub("\"", "\\\"")}\"" unless genre.nil?
    metadata.join(" ")
  end
  # rubocop:enable Metrics/AbcSize, Style/StringLiteralsInInterpolation
end
