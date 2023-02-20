# frozen_string_literal: true

module Api
  module V1
    class TracksController < ::Api::V1::Base
      include ActiveStorage::SetCurrent

      def index
        songs, count = Songs::UseCases::AllUsersSongs.call(context: context, params: params).data
        render json: Songs::Representers::Index.call(songs, count)
      end

      def show
        song = Song.find(params[:id])
        render json: Songs::Representers::Single.call(song)
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

      def destroy
        UserSong.find_by(user_id: current_user.id, song_id: params[:id]).delete
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
