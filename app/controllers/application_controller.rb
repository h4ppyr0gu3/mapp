# frozen_string_literal: true

class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :set_notifications

  def set_notifications
    if current_user.present?
      @notifications = current_user.notifications.order(created_at: :desc).first(10)
      @notifications_count = current_user.notifications.where(read: false).count
    else
      @notifications = []
    end
  end

  def context
    @context ||= {
      user: current_user,
      user_agent: request.user_agent
    }
  end
end
