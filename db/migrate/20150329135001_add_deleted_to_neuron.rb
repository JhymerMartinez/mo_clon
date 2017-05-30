class AddDeletedToNeuron < ActiveRecord::Migration
  def change
    add_column :neurons, :deleted, :boolean, default: false
    add_index :neurons, :deleted
  end
end
