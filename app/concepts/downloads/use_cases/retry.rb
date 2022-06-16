# frozen_string_literal: true

module Downloads
  module UseCases
    class Retry < ::UseCase::Base
      def call
        clean_attributes
        song.destroy
        DownloadJob.perform_async(download_params)
      end

      private

      def song
        @song ||= Song.find(params[:id])
      end

      def clean_attributes
        download_params = song.attributes.symbolize_keys        
        download_params[:channel] = download_params[:album]
        download_params.except!(:album, :id, :genre, :updated, :created_at, :updated_at)
      end
    end
  end
end
