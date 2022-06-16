module Downloads
  module UseCases
    class Update < ::UseCase::Base
      def call
        # unless song.mp3.attached?
          # define in model
          # song.redownload
          # return nil unless song.mp3.attached?
        # end
      
        current_device = current_user.devices.find_or_create_by(user_agent: user_agent)
        repository.update_metadata(song, params) if song.updated != 2
        DeviceSong.find_or_create_by(device_id: current_device.id, song_id: song.id)
        return song
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

