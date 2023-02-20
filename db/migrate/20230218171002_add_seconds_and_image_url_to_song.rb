class AddSecondsAndImageUrlToSong < ActiveRecord::Migration[7.0]
  def change
    add_column :songs, :seconds, :integer
    add_column :songs, :image_url, :string
  end
end
