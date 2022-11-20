module Songs
  module Representers
    class Multiple # < ::Representers::Base
      class << self
        def call(songs)
          {
            songs: render_songs(songs)
          }
        end

        private

        def render_songs(songs)
          songs.map do |song|
            Songs::Representers::Single.call(song)
          end
        end
      end
    end
  end
end
