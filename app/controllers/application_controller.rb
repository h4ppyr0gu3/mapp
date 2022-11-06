# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  skip_before_action :verify_authenticity_token
  before_action :set_notifications

  def set_notifications
    @notifications = []
    @notifications_count = 0
    return if excluded_controller_and_action || @current_user.nil?

    @notifications = @current_user.notifications.order(created_at: :desc).first(10)
    @notifications_count = @current_user.notifications.where(read: false).count
  end

  def context
    @context ||= {
      user: @current_user,
      user_agent: request.user_agent
    }
  end

  def excluded_controller_and_action
    ["devise/registrations", "devise/sessions"].include?(params[:controller]) &&
      ["new"].include?(params[:action])
  end
end
