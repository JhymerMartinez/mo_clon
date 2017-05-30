class RemoveStateNeuron < ActiveRecord::Migration
  def up
    remove_column :neurons, :state
  end

  def down
    add_column :neurons, :state, :integer, default: 0
  end
end
