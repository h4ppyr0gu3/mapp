module Songs
  module Representers
    class Single
      class << self
        def call(song)
          {
            id: song.id,
            title: song.title,
            artist: song.artist,
            genre: song.genre,
            year: song.year,
            album: song.album,
            video_id: song.video_id
          }
        end
      end
    end
  end
end
