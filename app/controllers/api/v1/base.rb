# frozen_string_literal: true

module Api
  module V1
    class Base < ActionController::Base
      include DeviseTokenAuth::Concerns::SetUserByToken

      skip_before_action :verify_authenticity_token
      before_action :authenticate_user!

      def context
        {
          user: current_user,
          request_details: request_details
        }
      end

      def request_details
        {
          ip_addr: request.ip,
          user_agent: request.user_agent
        }
      end
    end
  end
end
