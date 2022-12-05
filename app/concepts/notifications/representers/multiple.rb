# frozen_string_literal: true

module Notifications
  module Representers
    class Multiple
      class << self
        def call(notifications)
          notifications.map do |notification|
            Notifications::Representers::Single.call(notification)
          end
        end
      end
    end
  end
end
