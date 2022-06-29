class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :user
      t.string :text
      t.boolean :read, default: false, null: false

      t.timestamps
    end
  end
end
