# frozen_string_literal: true

module Api
  module V1
    class DownloadsController < Api::V1::Base
      include ActiveStorage::SetCurrent

      def redirect
        song = Song.find(params[:id])
        song.redownload_mp3 unless song.mp3.attached?
        song.redownload_image unless song.image.attached?
        song.update_metadata unless song.written?

        if song.mp3.url.present?
          render json: { url: song.mp3.url}
        else
          render json: { errors: ["Song link doesn't exist, Please try later"] }
        end
      end
    end
  end
end
