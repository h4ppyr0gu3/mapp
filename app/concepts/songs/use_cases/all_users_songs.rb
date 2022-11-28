module Songs
  module UseCases
    class AllUsersSongs < ::UseCase::Base
      def call
        songs = current_user.songs
        songs = filtered(params[:filters], songs)
        @data = paginated(params[:pagination], songs)
        @data
      end

      def data
        [@data || [], current_user.songs.count]
      end

      private

      def filtered(filter_params, songs)
        return current_user.songs if filter_params.nil?

        songs = search_filter(songs, filter_params["queryField"], filter_params["query"])
        # sort_filter(songs, filter_params["sortBy"])
      end

      # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
      def search_filter(songs, query_field, query)
        return songs if query_field.nil?

        case query_field
        when "all"
          filter_all(songs, query)
        when "title"
          songs.where("title ilike '%#{query}%'")
        when "artist"
          songs.where("artist ilike '%#{query}%'")
        when "album"
          songs.where("album ilike '%#{query}%'")
        when "genre"
          songs.where("genre ilike '%#{query}%'")
        when "year"
          songs.where("year ilike '%#{query}%'")
        end
      end
      # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity

      def sort_filter(songs, sort_by)
        songs = sort_by_default(songs) if sort_by == "default"
        songs = sort_by_artist(songs) if sort_by == "artist"
        sort_by_genre(songs) if sort_by == "genre"
      end

      def filter_all(songs, query)
        songs.where("title ilike '%#{query}%' or artist ilike '%#{query}%' \
             or album ilike '%#{query}%' or genre ilike '%#{query}%' \
             or year ilike '%#{query}%'")
      end

      def paginated(pagination_params, songs)
        return songs.limit(20) if pagination_params.nil?
        songs.offset(pagination_params[:offset] || 0)
             .limit(pagination_params[:limit] || 20)
      end

      def sort_by_default(songs)
        songs.order(created_at: :asc)
      end

      def sort_by_artist(songs)
        songs.order(artist: :asc)
      end

      def sort_by_title(songs)
        songs.order(title: :asc)
      end
    end
  end
end
