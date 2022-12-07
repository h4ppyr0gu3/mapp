# frozen_string_literal: true

module Api
  module V1
    class NotificationsController < ::Api::V1::Base
      def index
        notifications = current_user.notifications.where(read: false)
        render json: Notifications::Representers::Index.call(notifications)
      end

      def update
        Notification.find_by(user_id: current_user.id, id: params[:id]).update(read: true)

        redirect_to action: :index
      end
    end
  end
end
