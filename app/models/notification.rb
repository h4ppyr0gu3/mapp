# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :user, dependent: :destroy
  validates :user_id, presence: true

  after_save do
    ::NotificationsChannel.broadcast_to("notifications_for_#{user.uuid}", self)
  end
end
