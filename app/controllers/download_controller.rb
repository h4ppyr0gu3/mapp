# frozen_string_literal: true

class DownloadController < ApplicationController
  include Zipline
  def retry
    Downloads::UseCases::Retry.new(params:).call
    redirect_back fallback_location: songs_path, notice: "Retrying Download...."
  end

  # called from js fetch
  def external
    Downloads::UseCases::External.new(params: download_params, context:).call
  end

  def internal
    song = Downloads::UseCases::Internal.new(params:, context:).call
    redirect_to url_for(song) unless song.nil?
  end

  def all
    job_params = {
      user_id: current_user.id,
      user_agent: request.user_agent,
      context:
    }.to_json
    # files = Downloads::UseCases::All.new(params: request.user_agent, context:).call
    pp job_params
    ZipJob.perform_async(job_params)
    redirect_back fallback_location: songs_path, notice: "Zipping files, you will be notified when it is done."
    # zipline(files, "mapp.zip")
  end

  def update
    song = Downloads::UseCases::Update.new(params:, context:).call
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
