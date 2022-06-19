# frozen_string_literal: true

module Songs
  module UseCases
    class FindArtists
      class << self
        def call(params)
          response = call_api(params)
          clean_response(response)
        end

        private

        def clean_response(res)
          res_hash = { artists: [] }
          res["artists"][0..4].each do |artist|
            next if artist.nil?

            res_hash[:artists] << {
              id: artist["id"],
              name: artist["name"],
              country: artist["country"]
            }
          end
          res_hash
        end

        def call_api(params)
          resource = "/ws/2/artist"
          query = { query: params[:artist] }
          repository.musicbrainz_request(resource, query)
        end

        def repository
          ::Songs::Repository
        end
      end
    end
  end
end
