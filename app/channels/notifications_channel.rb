class NotificationsChannel < ApplicationCable::Channel
  def connect
    puts cookies
  end

  def subscribed
    stream_for "notifications_for_#{params[:uuid]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
