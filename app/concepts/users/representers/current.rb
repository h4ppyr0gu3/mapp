# frozen_string_literal: true

module Users
  module Representers
    class Current
      class << self
        def call(user)
          {
            email: user.email,
            songs: user.songs.count
          }
        end
      end
    end
  end
end
