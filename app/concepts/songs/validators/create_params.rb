# frozen_string_literal: true

module Songs
  module Validators
    class CreateParams < ::Dry::Validation::Contract
      params do
        required(:title).filled(:string)
        optional(:genre).value(:string)
        optional(:album).value(:string)
        optional(:year).value(:string)
        optional(:artist).value(:string)
      end
    end
  end
end
