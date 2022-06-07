class CreateDeviceSongs < ActiveRecord::Migration[7.0]
  def change
    create_table :device_songs do |t|

      t.references :song
      t.references :device
      t.timestamps
    end
  end
end
