module Songs
  module UseCases
    class AllUsersSongs < ::UseCase::Base
      def call
        puts "putsing"
        songs = current_user.songs
        filtered(params[:filters], songs)
        paginated(params[:pagination], songs)
        puts "done putsing"
      end

      def data
        current_user.songs
      end

      private

      def filtered(filter_params, songs)
        songs = search_filter(songs, filter_params["queryField"])
        sort_filter(songs, filter_params["sortBy"])
      end

      def search_filter(songs, query_field)
        return songs if query_field.nil?
        songs = filter_title(songs) if query_field == "title"
        songs = filter_artist(songs) if query_field == "artist"
        filter_genre(songs) if query_field == "genre"
      end

      def sort_filter(songs, sort_by)
        songs = sort_by_default(songs) if sort_by == "default"
        songs = sort_by_artist(songs) if sort_by == "artist"
        sort_by_genre(songs) if sort_by == "genre"
      end

      def paginated(pagination_params, songs)
        puts pagination_params
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
