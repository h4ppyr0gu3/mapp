class DownloadController < ApplicationController
  def get
    download_params
    pp params
    DownloadJob.perform_async(
      params["video_id"], 
      params["image_url"], 
      params["title"], 
      params["channel"],
      params["user_id"]
    )
    head :no_content
    return
  end

  private

  def download_params
    params.permit(
      :image_url,
      :video_id,
      :user_id,
      :title,
      :channel_name,
    )
  end
end
