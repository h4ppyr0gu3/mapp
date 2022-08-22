# frozen_string_literal: true

class NotificationsController < ApplicationController
  def get_uuid
    return nil unless current_user

    uuid = SecureRandom.uuid
    current_user.update(uuid:)
    render json: { uuid: }
  end

  def mark_as_read
    current_user.notifications.each do |notification|
      notification.update(read: true)
    end
  end
end
