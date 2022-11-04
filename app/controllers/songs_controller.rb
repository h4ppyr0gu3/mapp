# frozen_string_literal: true

class SongsController < ApplicationController
  before_action :set_song, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[user_index show new edit create update delete]

  def index
    @q = Song.all.ransack(params[:q])
    @songs = @q.result.page(params[:page])
  end

  def update_all_metadata
    Song.all.each do |song|
      UpdateMetadataJob.perform_async(song.id)
    end
    redirect_back fallback_location: songs_path, notice: "All songs are being updated now..."
  end

  def user_index
    @q = current_user.songs.ransack(params[:q])
    @songs = @q.result.page(params[:page])
  end

  def user_updated
    @q = current_user.songs.where("updated >= 1").ransack(params[:q])
    @songs = @q.result.page(params[:page])
  end

  def user_not_updated
    @q = current_user.songs.where(updated: 0).ransack(params[:q])
    @songs = @q.result.page(params[:page])
  end

  def auto_fill
    response = ::Songs::UseCases::AutoFill.call(params)
    # Net::HTTP.get("https://musicbrainz.org/ws/2/artist?query=post+malone&limit=1&offset=0")
    render json: response.to_json
  end

  def album_list
    response = ::Songs::UseCases::FindArtistsAlbums.call(params)
    render json: response.to_json
  end

  # def album_list
  #   response = ::Songs::UseCases::FindAlbumsSongs.call(params)
  #   render json: response.to_json
  # end

  def show; end

  def new
    @song = Song.new
  end

  def edit; end

  def create
    @song = Song.new(song_params)

    respond_to do |format|
      if @song.save
        format.html { redirect_to song_url(@song), notice: "Song was successfully created." }
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
      redirect_back fallback_location: songs_path, notice: "Song was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @song.destroy

    respond_to do |format|
      format.html { redirect_to songs_url, notice: "Song was successfully destroyed." }
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
