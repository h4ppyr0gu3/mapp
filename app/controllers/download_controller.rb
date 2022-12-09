# frozen_string_literal: true

class DownloadController < ApplicationController
  include Zipline
  def retry
    Downloads::UseCases::Retry.new(params: params).call
    redirect_back fallback_location: songs_path, notice: "Retrying Download...."
  end

  def redownload_all
    Song.all.pluck(:video_id).map do |video_id|
      song_params = {
        video_id: video_id,
        image_url: "https://img.youtube.com/vi/#{video_id}/hqdefault.jpg"
      }.to_json
      RedownloadJob.perform_async(song_params)
    end
    redirect_back fallback_location: songs_path, notice: "All songs are being redownloaded now..."
  end

  def redownload_all
    Song.all.pluck(:id).map do |video_id|
      # song_params = {
      #   vid: video_id,
      #   image_url: "https://img.youtube.com/vi/#{video_id}/hqdefault.jpg"
      # }.to_json
      RedownloadJob.perform_async(video_id)
    end
  end

  # called from js fetch
  def external
    Downloads::UseCases::External.new(params: download_params, context: context).call
  end

  def internal
    song = Downloads::UseCases::Internal.new(params: params, context: context).call
    redirect_to url_for(song) unless song.nil?
  end

  def all
    job_params = {
      user_id: current_user.id,
      user_agent: request.user_agent,
      context: context
    }.to_json
    # files = Downloads::UseCases::All.new(params: request.user_agent, context:).call
    pp job_params
    ZipJob.perform_async(job_params)
    redirect_back fallback_location: songs_path, notice: "Zipping files, you will be notified when it is done."
    # zipline(files, "mapp.zip")
  end

  def update
    song = Downloads::UseCases::Update.new(params: params, context: context).call
    if song.mp3.nil?
      redirect_back fallback_location: songs_path, alert: "Song is not available at the moment"
    else
      redirect_to url_for(song.mp3) unless song.nil?
    end
  end

  private

  def download_params
    params.permit(
      :image_url,
      :video_id,
      :user_id,
      :title,
      :channel
    )
  end
end
