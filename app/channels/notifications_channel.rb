# frozen_string_literal: true

class NotificationsChannel < ApplicationCable::Channel
  def connect
    puts cookies
  end

  def subscribed
    stream_for "notifications_for_#{params[:uuid]}"
    stream_backlog
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private

  def stream_backlog
    user = User.find_by(uuid: params[:uuid])
    notes = Notification.where(user_id: user.id, read: false)
    notes.each do |note|
      NotificationsChannel.broadcast_to("notifications_for_#{params[:uuid]}", note)
    end
  end
end
