# frozen_string_literal: true

class UpdateMetadataJob
  include Sidekiq::Job
  sidekiq_options retry: 2

  def perform(id)
    song = Song.find(id)
    song.update_metadata
  rescue ActiveRecord::RecordNotFound
    clean_broken_relations(id)
  end

  private

  def clean_broken_relations(id)
    UserSong.where(song_id: id).delete_all
    DeviceSong.where(song_id: id).delete_all
  end
end

