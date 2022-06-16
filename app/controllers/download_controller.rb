# frozen_string_literal: true

include Zipline

class DownloadController < ApplicationController
  def get
    song = Downloads::UseCases::Get.new(params: download_params).call.nil?
    redirect_to url_for(song) unless song.nil?
    head :no_content
    nil
  end

  def retry
    Downloads::UseCases::Retry.new(params: params).call
    redirect_back fallback_location: songs_path, notice: 'Retrying Download....'
  end

  # called from js fetch
  def external
    song = Downloads::UseCases::External.new(params: download_params, context: context).call
    # binding.pry
    # if song.nil?
      # redirect_back fallback_location: search_path,
      # notice: 'We are fetching the song now, it will be available in a few minutes'
    # else
    #   redirect_to url_for(song.mp3) unless song.mp3.nil?
    # end
  end

  def internal
    song = Downloads::UseCases::Internal.new(params: params, context: context).call
    redirect_to url_for(song) unless song.nil?
  end

  def all
    files = Downloads::UseCases::All.new(params: request.user_agent, context: context).call
    zipline(files, 'mapp.zip')
  end


  def update
    song = Downloads::UseCases::Update.new(params: params, context: context).call
    if song.mp3.nil?
      redirect_back fallback_location: songs_path, alert: 'Song is not available at the moment'
    else
      redirect_to url_for(song.mp3) unless song.nil?
    end
  end

  def download_all
    available_ids = []
    current_user.songs.each do |song|
      if song.mp3.attached?
        update_metadata(song) if song.updated != 2
        available_ids << song.id
      end
    end
    device = current_user.devices.find_or_create_by(user_agent: request.user_agent)
    undownloaded_songs = current_user.songs.where.not(id: device.songs.ids)
    available_songs = undownloaded_songs.where(id: available_ids)
    device.songs << available_songs
    files = available_songs.map { |song| [song.mp3, song.mp3.filename] }
    zipline(files, 'mapp.zip')
  end

  private

  def download_params
    params.permit(
      :image_url,
      :video_id,
      :user_id,
      :title,
      :channel
    )
  end
end
