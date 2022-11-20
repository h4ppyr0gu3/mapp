# frozen_string_literal: true

module UseCase
  class Base
    class << self
      def call(params:, context: {})
        new(params: params, context: context).tap(&:call)
      end
    end

    attr_reader :params, :context, :errors

    def initialize(params:, context: {})
      @params = params
      @context = context
      @errors = []
    end

    def call
      raise NotImplementedError, "#call method must be implemented"
    end

    def data
      raise NotImplementedError, "#data method must be implemented"
    end

    private

    def step(method)
      send(method)
      return unless errors.empty?
    end

    def add_error(message)
      errors.append(message)
    end

    def current_user
      @current_user ||= context[:user]
    end

    def user_agent
      @user_agent ||= context[:user_agent]
    end
  end
end
