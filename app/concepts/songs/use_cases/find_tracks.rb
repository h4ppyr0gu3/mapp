# frozen_string_literal: true

module Songs
  module UseCases
    class FindTracks
      class << self
        def call(params)
          all_tracks = get_tracks(params)
          possible_tracks = search_tracks(params, all_tracks)
          { tracks: possible_tracks }
        end

        private

        def search_tracks(params, all_tracks)
          strings = params[:title].downcase.split
          downcased = title_array(all_tracks)
          occurences = []
          strings.map do |string|
            occurences << downcased.map.with_index { |x, i| [x, i] if x.include?(string) }
          end
          indexes = collect_indexes(occurences.compact)
          deduplicate(indexes, all_tracks)
        end

        def deduplicate(indexes, all_tracks)
          tracks = []
          indexes.map do |index|
            tracks << all_tracks[index]
          end
          tracks.uniq { |track| track["title"] }
        end

        # rubocop:disable Metrics/AbcSize
        def collect_indexes(vals)
          ints = []
          vals.flatten.map { |val| ints << val if val.is_a?(Integer) }
          h = {}
          ints.map do |int|
            h[int] = 0 if h[int].nil?
            h[int] = h[int] + 1
          end
          index_weights = h.sort_by { |_k, v| -v }
          index_weights.map { |arr| arr[0] }
        end
        # rubocop:enable Metrics/AbcSize

        def title_array(all_tracks)
          titles = []
          all_tracks.map do |track|
            titles << track["title"].downcase
          end
          titles
        end

        def get_tracks(params)
          resource = "/ws/2/recording"
          query = { artist: params[:artist_id], limit: 100 }
          first_request = repository.musicbrainz_request(resource, query)
          return first_request["recordings"] if first_request["recording-count"] < 100

          Rails.cache.fetch("artists_#{params[:artist_id]}", expires_in: 12.hours) do
            get_all_tracks(params, first_request)
          end
        end

        def get_all_tracks(params, first_request)
          tracks = first_request["recordings"]
          tracks << get_remaining_tracks(first_request["recording-count"], params)
          tracks.flatten.compact
        end

        def cached_tracks(params)
          Rails.cache.fetch("artists_#{params[:artist_id]}", expires_in: 12.hours) do
            get_tracks(params)
          end
        end

        def get_remaining_tracks(count, params)
          tracks = []
          reqs = (count / 100.0).ceil
          (1..reqs).each do |i|
            resource = "/ws/2/recording"
            query = { artist: params[:artist_id], offset: (i * 100), limit: 100 }
            res = repository.musicbrainz_request(resource, query)
            tracks << res["recordings"]
          end
          tracks
        end

        def repository
          ::Songs::Repository
        end
      end
    end
  end
end
