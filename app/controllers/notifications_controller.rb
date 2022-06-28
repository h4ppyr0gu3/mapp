class NotificationsController < ApplicationController
  def get_uuid
    return nil unless current_user

    uuid = SecureRandom.uuid
    current_user.update(uuid: uuid)
    render json: {uuid: uuid}
  end
end
