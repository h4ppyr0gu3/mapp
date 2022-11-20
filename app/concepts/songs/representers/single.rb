# frozen_string_literal: true

module Songs
  module Representers
    class Single
      class << self
        # rubocop:disable Metrics/MethodLength
        def call(song)
          {
            id: song.id,
            video_id: song.video_id,
            updated_integer: song.updated_before_type_cast,
            updated_value: song.updated,
            artist: song.artist,
            title: song.title,
            genre: song.genre,
            album: song.album,
            year: song.year
          }
        end
        # rubocop:enable Metrics/MethodLength
      end
    end
  end
end
