class DownloadController < ApplicationController
  def get
    download_params
    if Song.exists?(video_id: params[:video_id])
      head :no_content
      return
    else
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
