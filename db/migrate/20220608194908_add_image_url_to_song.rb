class AddImageUrlToSong < ActiveRecord::Migration[7.0]
  def change
    add_column :songs, :image_url, :string
  end
end
