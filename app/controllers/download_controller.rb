# frozen_string_literal: true

class DownloadController < ApplicationController
  include DownloadHelper

  def get
    download_params
    return if Song.exists?(video_id: params[:video_id])

    call_download_job
    head :no_content
    nil
  end

  def call_download_job
    DownloadJob.perform_async(
      params['video_id'],
      params['image_url'],
      params['title'],
      params['channel'],
      params['user_id']
    )
  end

  def update_download
    song = Song.find_by(video_id: params[:video_id])
    update_metadata(song) if song.updated != 2

    redirect_to url_for(song.mp3)
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
