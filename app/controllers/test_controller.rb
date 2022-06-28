class TestController < ApplicationController
  def test
    NotificationsChannel.broadcast_to("notifications_for_#{current_user.uuid}", {test: "do you copy"})
  end
end
