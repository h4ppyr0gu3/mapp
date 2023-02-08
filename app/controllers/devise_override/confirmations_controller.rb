# frozen_string_literal: true

module DeviseOverride
  class ConfirmationsController < DeviseTokenAuth::ConfirmationsController
    def show
      @resource = resource_class.confirm_by_token(resource_params[:confirmation_token])
      if @resource.errors.empty?
        render json: { success: true, message: "Account Confirmed", email: @resource.email }
      else
        render json: { errors: @resource.errors }
        # redirect_to DeviseTokenAuth::Url.generate(redirect_url, account_confirmation_success: false)
      end
    end

    def create
      super
    end
  end
end
