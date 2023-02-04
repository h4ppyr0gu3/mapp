# frozen_string_literal: true

module Api
  module V1
    class MiscellaneousController < Api::V1::Base
      def whoami
        if current_user.present?
          render json: {
            success: true,
            user: Users::Representers::Current.call(current_user)
          }
        else
          render json: { success: false }, status: 422
        end
      end
    end
  end
end
