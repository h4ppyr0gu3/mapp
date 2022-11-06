module Api
  module V1
    class Base < ActionController::Base
      include DeviseTokenAuth::Concerns::SetUserByToken
    end
  end
end
