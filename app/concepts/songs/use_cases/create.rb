module Songs
  module UseCases
    class Create < ::UseCase::Base
      def call
        step :validate_params
      end

      def data
        nil
      end

      private

      def validate_params
        binding.pry
      end
    end
  end
end
