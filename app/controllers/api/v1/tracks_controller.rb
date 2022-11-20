module Api
  module V1
    class TracksController < ::Api::V1::Base
      def index
        return nil if current_user.nil?

        render json: Songs::Representers::Multiple.call(current_user.songs)
      end

      def show; end

      def post; end

      def create
        song = Songs::UseCases::Create.call(params: params).data

        render json: Songs::Representers::Single.call(song)
      end
    end
  end
end
