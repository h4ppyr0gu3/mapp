# frozen_string_literal: true

module Notifications
  module Representers
    class Single
      class << self
        def call(notification)
          {
            id: notification.id,
            read: notification.read,
            created_at: notification.created_at,
            text: notification.text,
            link: notification.link
          }
        end
      end
    end
  end
end
