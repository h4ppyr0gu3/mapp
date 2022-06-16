require 'net/http'
require 'cgi'
require 'json'

module Songs
  module UseCases
    class AutoFill
      class << self
        def call(params)
          params = { artist: "Post Malone" }
          response = nil
          response = if params[:artist]
            find_artists(params)
          end
          response
        end

        private

        def find_artists(params)
          resource = "/ws/2/artist"
          query = { query: params[:artist] }
          response = request(resource, query)
          json = JSON.parse(response)
          res_hash = {artists: []}
          json["artists"][0..4].each do |artist|
            next if artist.nil?
            res_hash[:artists] << {
              id: artist["id"], 
              name: artist["name"],
              country: artist["country"]
            }
          end
          return res_hash
        end

        def request(url, params)
          base = "https://musicbrainz.org"
          uri = URI((base + url))
          headers = {
            "Application": "mapp/1.0.0 ( rogersdpdr@gmail.com)",
            "Accept": "application/json",
            "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:101.0) Gecko/20100101 Firefox/101.0"
          }
          uri.query = URI.encode_www_form(params)
          Net::HTTP.get(uri, headers)
        end
      end
    end
  end
end
