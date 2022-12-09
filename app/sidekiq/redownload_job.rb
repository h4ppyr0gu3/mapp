# frozen_string_literal: true

require "down"

class RedownloadJob
  include Sidekiq::Job
  sidekiq_options retry: 3

  def perform(id)
    song = Song.find(id)
    song.redownload_mp3
    song.redownload_image
  rescue ActiveRecord::RecordNotFound
    clean_broken_relations(id)
  end

  private

  def clean_broken_relations(id)
    # UserSong.where(song_id: id).delete_all
    # could notify users that this was deleted or download
    # first match from api search
    DeviceSong.where(song_id: id).delete_all
  end
end
