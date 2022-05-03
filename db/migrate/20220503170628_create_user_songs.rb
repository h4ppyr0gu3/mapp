class CreateUserSongs < ActiveRecord::Migration[7.0]
  def change
    create_table :user_songs do |t|
      t.integer :song_id
      t.integer :user_id

      t.timestamps
    end
  end
end
