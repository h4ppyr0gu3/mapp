require 'net/http'
require 'cgi'
require 'json'

module Songs
  module UseCases
    class AutoFill
      class << self
        def call(params)
          response = nil
          response = if params[:artist]
                       find_artists(params)
                     elsif params[:artist_id]
                       find_tracks(params)
                     elsif params[:song_id]
                       find_song(params)
                     end
          response
        end

        private

        def find_song(params)
          resource = "/ws/2/release"
          query = {
            recording: params[:song_id],
            inc: "genres",
            limit: 100
          }
          response = request(resource, query)
          album = album_data(response)
          album
        end

        # {title: album title, genre: genre, date: date}

        def album_data(response)
          valid = []
          releases = response["releases"]
          releases.map do |release|
            rel = {}
            # next unless release["text-representation"]["language"] == "eng" || release["text-representation"]["language"].nil?
            rel[:date] = release["date"][0..3]
            rel[:title] = release["title"]
            if release["genres"].empty?
              rel[:genre] = "unknown" 
            else
              gen = []
              release["genres"].map do |genre|
                gen << genre["name"]
              end
              rel[:genre] = gen.join(" ")
            end
            valid << rel
          end
          valid[0]
        end

        def find_tracks(params)
          resource = "/ws/2/recording"
          query = {
            artist: params[:artist_id],
            limit: 100
          }
          all_tracks = get_all_tracks(params)
          tracks = search_tracks(params, all_tracks)
          {tracks: tracks}
        end

        def search_tracks(params, all_tracks)
          strings = params[:title].downcase.split " "
          downcased = title_array(all_tracks)
          occurences = []
          strings.map do |string|
            occurences << downcased.map.with_index.select { |x, | x =~ /#{string}/ }
          end
          indexes = collect_indexes(occurences)
          deduplicate(indexes, all_tracks)
        end

        def deduplicate(indexes, all_tracks)
          tracks = []
          indexes.map do |index|
            tracks << all_tracks[index]
          end
          unique_tracks = tracks.uniq { |track| track["title"] }
          unique_tracks
        end

        def collect_indexes(vals)
          ints = []
          vals.flatten.map { |val| ints << val if val.is_a?(Integer) }
          h = {}
          ints.map do |int|
            h[int] = 0 if h[int].nil?
            h[int] = h[int] + 1
          end
          index_weights = h.sort_by { |k, v| -v }
          ordered_indexes = index_weights.map { |arr| arr[0] }
        end

        def title_array(all_tracks)
          titles = []
          all_tracks.map do |track|
            titles << track["title"].downcase
          end
          titles
        end

        def get_all_tracks(params)
          resource = "/ws/2/recording"
          query = {
            artist: params[:artist_id],
            limit: 100
          }
          first_request = request(resource, query)
          return first_request["recordings"] if first_request["recording-count"] < 100
          tracks = first_request["recordings"]
          tracks << get_remaining_tracks(first_request["recording-count"], params)
          tracks.flatten.compact
        end
        
        def get_remaining_tracks(count, params)
          count = count - 100 
          tracks = []
          while count > 0 do 
            count = count - 100
            resource = "/ws/2/recording"
            query = {
              artist: params[:artist_id],
              offset: count,
              limit: 100
            }
          res = request(resource, query)
          tracks << res["recordings"]
          tracks.flatten!
          end
          tracks
        end

        def find_artists(params)
          resource = "/ws/2/artist"
          query = { query: params[:artist] }
          res = request(resource, query)
          res_hash = {artists: []}
          res["artists"][0..4].each do |artist|
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
          raw = Net::HTTP.get(uri, headers)
          JSON.parse(raw)
        end
      end
    end
  end
end
