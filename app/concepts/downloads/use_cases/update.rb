# frozen_string_literal: true

module Downloads
  module UseCases
    class Update < ::UseCase::Base
      def call
        return if song.nil? || !song.mp3.attached?

        # unless song.mp3.attached?
        # define in model
        # song.redownload
        # return nil unless song.mp3.attached?
        # end

        ActiveRecord::Base.transaction do
          current_device = current_user.devices.find_or_create_by(user_agent:)
          song.update_metadata unless song.written?
          DeviceSong.find_or_create_by(device_id: current_device.id, song_id: song.id)
        end
        song
      end

      private

      def song
        @song ||= Song.find_by(video_id: params[:video_id])
      end

      def repository
        ::Downloads::Repository
      end
    end
  end
end
