class RemoveImageUrlFromSong < ActiveRecord::Migration[7.0]
  def change
    remove_column :songs, :image_url
  end
end
