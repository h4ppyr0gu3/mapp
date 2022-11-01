# frozen_string_literal: true

module Songs
  module UseCases
    class FindArtistsAlbums
      class << self
        def call(params)
          albums = get_albums(params)
          { albums: possible_albums(albums) }
        end

        private

        def possible_albums(albums)
          albums.each_with_object([]) do |album, obj|
            obj << {
              title: album["title"],
              album_id: album["id"],
              date: album["date"]
            }
          end
        end

        def get_albums(params)
          resource = "/ws/2/release"
          query = { artist: params[:artist_id], limit: 100 }
          albums = repository.musicbrainz_request(resource, query)
          return albums["releases"] if albums["release-count"] < 100

          # handle multiple requests to get all albums
          albums["releases"]
        end

        def repository
          ::Songs::Repository
        end
      end
    end
  end
end
