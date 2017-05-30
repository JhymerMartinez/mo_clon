class AddDeletedNeuron < ActiveRecord::Migration
  def up
    add_column :neurons, :deleted, :boolean, default: false
    add_index :neurons, :deleted
  end

  def down
    remove_column :neurons, :deleted
    remove_index :neurons, :deleted
  end
end
