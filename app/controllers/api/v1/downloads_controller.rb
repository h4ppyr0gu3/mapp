# frozen_string_literal: true

module Api
  module V1
    class DownloadsController < Api::V1::Base
      include ActiveStorage::SetCurrent

      def redirect
        redirect_to(Song.find(params[:id]).mp3.url)
      end
    end
  end
end
