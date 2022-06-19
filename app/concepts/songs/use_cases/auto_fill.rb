# frozen_string_literal: true

require "net/http"
require "cgi"
require "json"

module Songs
  module UseCases
    class AutoFill
      class << self
        def call(params)
          if params[:artist]
            ::Songs::UseCases::FindArtists.call(params)
          elsif params[:artist_id]
            ::Songs::UseCases::FindTracks.call(params)
          elsif params[:song_id]
            ::Songs::UseCases::SongAttributes.call(params)
          end
        end
      end
    end
  end
end
