# frozen_string_literal: true

module Songs
  module Validators
    class UpdateParams < ::Dry::Validation::Contract
      params do
        required(:id).filled(:integer)
        required(:video_id).filled(:string)
        required(:title).filled(:string)
        required(:genre).value(:string)
        required(:album).value(:string)
        required(:artist).value(:string)
        required(:year).value(:string)
      end
    end
  end
end
