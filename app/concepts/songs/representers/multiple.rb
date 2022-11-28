# frozen_string_literal: true

module Songs
  module Representers
    # < ::Representers::Base
    class Multiple
      class << self
        def call(songs)
          songs.map do |song|
            Songs::Representers::Single.call(song)
          end
        end
      end
    end
  end
end
