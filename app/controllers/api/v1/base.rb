module Api
  module V1
    class Base < ActionController::Base
      include DeviseTokenAuth::Concerns::SetUserByToken

      skip_before_action :verify_authenticity_token
      before_action :authenticate_user!
    end
  end
end
