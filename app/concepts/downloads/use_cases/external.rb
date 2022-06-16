module Downloads
  module UseCases
    class External < UseCase::Base
      def call
        song = Song.find_by(video_id: params[:video_id])
        return song unless song.nil?
        repository.call_download_job(params)
        return song
      end

      def repository
        ::Downloads::Repository
      end
    end
  end
end
