# frozen_string_literal: true

module DeviseOverride
  class ConfirmationsController < DeviseTokenAuth::ConfirmationsController
    protected

    def after_confirmation_path_for(_resource_name, _resource)
      "http://localhost:3001"
    end
  end
end
