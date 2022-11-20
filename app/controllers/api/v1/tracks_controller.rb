# frozen_string_literal: true

module Api
  module V1
    class TracksController < ::Api::V1::Base
      def index
        render json: Songs::Representers::Multiple.call(current_user.songs)
      end

      def update
        song = Songs::UseCases::Update.call(
          params: clean_params,
          context: context
        ).data

        render json: json_data(
          song, Songs::Representers::Single
        )
      end

      def create
        song = Songs::UseCases::Create.call(
          params: clean_params,
          context: context
        ).data

        render json: json_data(
          song, Songs::Representers::Single
        )
      end

      private

      def json_data(response, representer)
        {
          data: data(response, representer),
          errors: response[:errors]
        }
      end

      def data(response, representer)
        representer.call(response[:data]) if response[:errors].empty?
      end

      def clean_params
        params.permit!.to_h
      end
    end
  end
end
