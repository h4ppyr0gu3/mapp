class TestController < ApplicationController
  def test
    NotificationsChannel.broadcast_to("notifications", {test: "do you copy"})
  end
end
