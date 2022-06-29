# frozen_string_literal: true

module Downloads
  module UseCases
    class All < UseCase::Base
      def call
        available_ids = find_available_ids
        device = current_user.devices.find_or_create_by(user_agent:)
        undownloaded_songs = current_user.songs.where.not(id: device.songs.ids)
        available_songs = undownloaded_songs.where(id: available_ids)
        device.songs << available_songs
        uniqify(available_songs)
      end

      private

      def current_user
        @current_user ||= User.find(context[:user][:id])
      end

      def find_available_ids
        available_ids = []
        current_user.songs.each do |song|
          if song.mp3.attached?
            repository.update_metadata(song) if song.updated != 2
            available_ids << song.id
          end
        end
        available_ids
      end

      def uniqify(songs)
        flagged = find_duplicated(songs)
        count = 0
        songs.map do |song|
          if flagged.include?(song.title)
            count += 1
            [song.mp3, "#{song.mp3.filename}#{count}"]
          else
            [song.mp3, song.mp3.filename]
          end
        end
      end

      def find_duplicated(songs)
        titles = songs.pluck(:title)
        titles_dup = titles.dup
        flagged = []
        titles.map do |title|
          flagged << title if titles_dup.grep(/#{title}/).count > 1
        end
        flagged
      end

      def repository
        ::Downloads::Repository
      end
    end
  end
end
