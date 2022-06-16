module Downloads
  module UseCases
    class All < UseCase::Base
      def call
        available_ids = []
        current_user.songs.each do |song|
          if song.mp3.attached?
            repository.update_metadata(song) if song.updated != 2
            available_ids << song.id
          end
        end
        device = current_user.devices.find_or_create_by(user_agent: user_agent)
        undownloaded_songs = current_user.songs.where.not(id: device.songs.ids)
        available_songs = undownloaded_songs.where(id: available_ids)
        device.songs << available_songs
        files = available_songs.map { |song| [song.mp3, song.mp3.filename] }
        return files
      end

      private

      def repository
        ::Downloads::Repository
      end
    end
  end
end
