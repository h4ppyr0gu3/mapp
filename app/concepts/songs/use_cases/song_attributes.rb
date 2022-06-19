# frozen_string_literal: true

module Songs
  module UseCases
    class SongAttributes
      class << self
        def call(params)
          song_data(params)
        end

        private

        def song_data(params)
          albums = album_data(params)
          artists = artist_data(params)
          artists = { artists: song_artists(artists) }
          info = clean_albums(albums)
          info.merge!(artists)
        end

        def album_data(params)
          resource = "/ws/2/release"
          query = { recording: params[:song_id], inc: "genres", limit: 100 }
          repository.musicbrainz_request(resource, query)
        end

        def artist_data(params)
          resource = "/ws/2/artist"
          query = { recording: params[:song_id] }
          repository.musicbrainz_request(resource, query)
        end

        def song_artists(response)
          return "unknown" if response["artists"].empty?

          artists = []
          response["artists"].map do |artist|
            artists << artist["name"]
          end
          artists.join(" & ")
        end

        def clean_albums(response)
          valid = []
          releases = response["releases"]
          releases.map do |release|
            rel = set_release_attrs(release)
            rel[:genre] = sort_genres(release["genres"])
            valid << rel
          end
          clean_valid(valid)
        end

        def set_release_attrs(release)
          rel = {}
          rel[:date] = "unknown"
          rel[:date] = release["date"][0..3] unless release["date"].nil?
          rel[:title] = release["title"]
          rel[:lang] = release["text-representation"]["language"]
          rel
        end

        def clean_valid(valid)
          return { title: "unknown", date: "unknown", genre: "unknown" } if valid.empty?

          weighted_arr = valid.map.with_index { |alb, idx| [assign_weights(alb), idx] }
          sorted = weighted_arr.sort_by { |weight, _idx| -weight }
          valid[sorted[0][1]]
        end

        def assign_weights(album)
          weight = 0
          weight += 1 if album[:title].present?
          weight += 1 if album[:date].present?
          weight += 1 if album[:genre].present? && album[:genre] != "unknown"
          weight += 1 if album[:lang] == "eng"
          weight
        end

        def sort_genres(genres)
          return "unknown" if genres.empty?

          gens = genres.map do |genre|
            gen = []
            gen << genre["name"]
            gen.join(", ")
          end
          gens.uniq.join(", ")
        end

        def repository
          ::Songs::Repository
        end
      end
    end
  end
end
