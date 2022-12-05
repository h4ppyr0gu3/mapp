# frozen_string_literal: true

module Notifications
  module Representers
    class Index
      class << self
        def call(notifications)
          {
            notifications: Notifications::Representers::Multiple.call(notifications),
            total_count: notifications.count
          }
        end
      end
    end
  end
end
