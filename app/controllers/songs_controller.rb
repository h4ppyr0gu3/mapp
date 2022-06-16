# frozen_string_literal: true

class SongsController < ApplicationController
  before_action :set_song, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[user_index show new edit create update delete]

  def index
    @q = Song.all.ransack(params[:q])
    @songs = @q.result.page(params[:page])
  end

  def user_index
    @q = current_user.songs.ransack(params[:q])
    @songs = @q.result.page(params[:page])
  end

  def show; end

  def new
    @song = Song.new
  end

  def edit; end

  def create
    @song = Song.new(song_params)

    respond_to do |format|
      if @song.save
        format.html { redirect_to song_url(@song), notice: 'Song was successfully created.' }
        format.json { render :show, status: :created, location: @song }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    parsed_params = song_params.to_h
    # parsed_params = params.dup.to_h
    parsed_params.merge!({ updated: 1 }).except!(:id, :authenticity_token, :commit)
    pp parsed_params
    if @song.update(parsed_params)
      redirect_back fallback_location: songs_path, notice: 'Song was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @song.destroy

    respond_to do |format|
      format.html { redirect_to songs_url, notice: 'Song was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_song
    @song = Song.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def song_params
    params.require(:song).permit(:genre, :year, :title, :album, :artist)
  end
end
