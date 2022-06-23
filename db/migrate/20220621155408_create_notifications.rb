class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :user
      t.string :text
      t.boolean :read

      t.timestamps
    end
  end
end
