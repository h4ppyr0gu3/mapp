# frozen_string_literal: true

require "net/http"
require "cgi"
require "json"

module Songs
  class Repository
    class << self
      def musicbrainz_request(url, params)
        base = "https://musicbrainz.org"
        uri = URI((base + url))
        headers = {
          Application: "mapp/1.0.0 ( rogersdpdr@gmail.com)",
          Accept: "application/json",
          "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:101.0) Gecko/20100101 Firefox/101.0"
        }
        uri.query = URI.encode_www_form(params)
        raw = Net::HTTP.get(uri, headers)
        JSON.parse(raw)
      end
    end
  end
end
