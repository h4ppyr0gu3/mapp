class AddIndexes < ActiveRecord::Migration[7.0]
  def change
    add_index :device_songs, [:device_id, :song_id], unique: true
  end
end
