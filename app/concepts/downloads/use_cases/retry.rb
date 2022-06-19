# frozen_string_literal: true

module Downloads
  module UseCases
    class Retry < ::UseCase::Base
      def call
        clean_attributes
        DownloadJob.perform_async(job_params)
      end

      private

      def job_params
        {
          video_id: song.video_id,
          image_url: song.image_url
        }.to_json
      end

      def song
        @song ||= Song.find(params[:id])
      end

      def clean_attributes
        song.mp3.delete
        song.image.delete
      end
    end
  end
end
