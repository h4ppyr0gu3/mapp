class AddUuidToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :uuid, :string
  end
end
