class AddTreeImageToUser < ActiveRecord::Migration
  def change
    add_column :users, :tree_image, :string
  end
end
