# frozen_string_literal: true

class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def context
    @context ||= {
      user: current_user,
      user_agent: request.user_agent,
    }
  end
end
