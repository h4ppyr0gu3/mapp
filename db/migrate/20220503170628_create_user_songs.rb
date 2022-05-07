# frozen_string_literal: true

class CreateUserSongs < ActiveRecord::Migration[7.0]
  def change
    create_table :user_songs do |t|
      t.integer :song_id
      t.integer :user_id
      t.index %i[song_id user_id], unique: true
      t.timestamps
    end
  end
end
