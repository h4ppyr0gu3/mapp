# frozen_string_literal: true

module Songs
  module UseCases
    class Update < ::UseCase::Base
      def call
        step :validate_params
        step :update_song
      end

      def data
        {
          data: (@song.reload if @song.present?),
          errors: errors
        }
      end

      private

      def update_song
        song = Song.find(params[:id])
        song.update!(song_params)
        @song = song
      end

      def song_params
        {
          artist: params[:artist],
          title: params[:title],
          genre: params[:genre],
          album: params[:album],
          year: params[:year],
          seconds: params[:seconds],
          updated: 1
        }
      end

      def validator
        ::Songs::Validators::UpdateParams
      end
    end
  end
end
