# frozen_string_literal: true

class PlaylistController < ApplicationController
  def remove
    UserSong.find_by(user_id: current_user.id, song_id: params[:id]).delete
    redirect_back fallback_location: user_songs_path, notice: 'Removed Successfully'
  end

  def add
    UserSong.create(user_id: current_user.id, song_id: params[:id])
    redirect_back fallback_location: songs_path, notice: 'Added Successfully'
  end

  private

  def clean_params; end
end
