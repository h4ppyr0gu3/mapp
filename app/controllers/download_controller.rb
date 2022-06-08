# frozen_string_literal: true

include Zipline

class DownloadController < ApplicationController
  include DownloadHelper

  def get
    download_params
    return if Song.exists?(video_id: params[:video_id])

    call_download_job
    head :no_content
    nil
  end

  def retry_download
    song = Song.find(params[:id])
    download_params = song.attributes.symbolize_keys.except!(:id, :genre, :updated, :created_at ,:updated_at)
    download_params[:channel] = download_params[:album]
    download_params.except![:album]
    song.destroy
    DownloadJob.perform_async(download_params)
    redirect_back fallback_location: songs_path, notice: "Retrying Download...."
  end

  def call_download_job
    DownloadJob.perform_async({
      video_id: params['video_id'],
      image_url: params['image_url'],
      title: params['title'],
      channel: params['channel'],
      user_id: params['user_id']}
    )
  end

  def update_download
    current_device = current_user.devices.find_or_create_by(user_agent: request.user_agent)
    song = Song.find_by(video_id: params[:video_id])
    update_metadata(song) if song.updated != 2
    current_device.songs << song

    redirect_to url_for(song.mp3)
  end

  def download_all
    available_ids = []
    current_user.songs.each do |song|
      if song.mp3.attached?
        update_metadata(song) if song.updated != 2
        available_ids << song.id
      end
    end
    device = current_user.devices.find_or_create_by(user_agent: request.user_agent)
    undownloaded_songs = current_user.songs.where.not(id: device.songs.ids)
    available_songs = undownloaded_songs.where(id: available_ids)
    device.songs << available_songs
    files = available_songs.map{ |song| [song.mp3, song.mp3.filename] }
    zipline(files, 'mapp.zip')
  end

  private

  def download_params
    params.permit(
      :image_url,
      :video_id,
      :user_id,
      :title,
      :channel_name
    )
  end
end
