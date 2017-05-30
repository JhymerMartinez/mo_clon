class AddExtraInfoToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :role, :string, default: "cliente", null: false
  end
end
