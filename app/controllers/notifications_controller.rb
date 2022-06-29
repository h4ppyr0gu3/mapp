# frozen_string_literal: true

class NotificationsController < ApplicationController
  def get_uuid
    return nil unless current_user

    uuid = SecureRandom.uuid
    current_user.update(uuid:)
    render json: { uuid: }
  end

  # rubocop:disable Lint/SuppressedException
  def mark_as_read
    read_at = Notification.find_by(user_id: current_user.id, id: params[:id]).created_at
    Notification.where(user_id: current_user.id, read: false)
                .where("created_at <= ?", read_at)
                .each do |notification|
                  notification.update(read: true)
                end
  rescue NoMethodError
  end
  # rubocop:enable Lint/SuppressedException
end
