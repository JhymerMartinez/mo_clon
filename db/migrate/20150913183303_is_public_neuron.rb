class IsPublicNeuron < ActiveRecord::Migration
  def up
    add_column :neurons, :is_public, :boolean, default: false
  end

  def down
    remove_column :neurons, :is_public
  end
end
