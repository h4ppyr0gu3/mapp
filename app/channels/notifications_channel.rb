class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    puts params
    stream_for "notifications"
  end

  def recieved(params)
    puts JSON.parse(params)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
