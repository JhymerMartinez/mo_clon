class RemoveDeletedFromNeuron < ActiveRecord::Migration
  def up
    remove_index :neurons, :deleted
    remove_column :neurons, :deleted
  end

  def down
    add_column :neurons, :deleted, :boolean, default: false
    add_index :neurons, :deleted
  end
end
