# frozen_string_literal: true

module Songs
  module UseCases
    class Create < ::UseCase::Base
      attr_reader :song

      def call
        step :validate_params
        step :create_song
        step :associate_user
      end

      def data
        {
          data: (@song.reload if @song.present?),
          errors: errors
        }
      end

      private

      def create_song
        song = Song.find_or_create_by(
          video_id: params[:video_id]
        )
        song.update!(song_params) if song.vanilla?
        @song = song
      rescue ActiveRecord::RecordInvalid => e
        add_error(e.message)
      end

      def associate_user
        return if current_user.songs.pluck(:song_id).include?(@song.id)

        current_user.songs << @song
      end

      def song_params
        {
          artist: params[:artist],
          title: params[:title],
          genre: params[:genre],
          album: params[:album],
          year: params[:year]
        }
      end

      def validator
        ::Songs::Validators::CreateParams
      end
    end
  end
end
