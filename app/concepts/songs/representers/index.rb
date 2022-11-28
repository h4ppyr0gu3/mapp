module Songs
  module Representers
    class Index
      class << self
        def call(songs, count)
          {
            songs: ::Songs::Representers::Multiple.call(songs),
            total_count: count
          }
        end
      end
    end
  end
end
