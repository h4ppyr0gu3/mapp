class CreateDevices < ActiveRecord::Migration[7.0]
  def change
    create_table :devices do |t|
      t.string :device_name
      t.string :user_agent
      t.references :user

      t.timestamps
    end
  end
end
