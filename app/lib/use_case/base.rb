# frozen_string_literal: true

module UseCase
  class Base
    attr_reader :params, :context
    def initialize(params:, context: {})
      @params = params
      @context = context
    end

    private

    def current_user
      @current_user ||= context[:user] 
    end

    def user_agent 
      @user_agent ||= context[:user_agent]
    end
  end
end
