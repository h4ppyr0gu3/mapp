# frozen_string_literal: true

require "down"

class DownloadJob
  include Sidekiq::Job
  sidekiq_options retry: 3

  def perform(params)
    params = JSON.parse(params).symbolize_keys
    song = Song.find_by(video_id: params[:video_id])
    return redownload(song) unless song.nil?

    song = create_song(params)
    song.download_mp3
    song.download_image

    attach_user(params, song)
  end

  private

  def redownload(song)
    RedownloadJob(song).perform_async
  end

  def attach_user(params, song)
    return if params[:user_id].nil?

    ::UserSong.create(user_id: params[:user_id], song_id: song.id)
  end

  def create_song(params)
    song = Song.find_by(video_id: params[:video_id])
    return song unless song.nil?

    Song.create(
      title: params[:title],
      artist: params[:channel],
      video_id: params[:video_id],
      updated: :vanilla
    )
  end
end
