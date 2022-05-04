class CreateSongs < ActiveRecord::Migration[7.0]
  def change
    create_table :songs do |t|
      t.string :title
      t.string :artist
      t.string :year
      t.string :album
      t.string :genre
      t.string :video_id
      t.index :video_id

      t.timestamps
    end
  end
end
