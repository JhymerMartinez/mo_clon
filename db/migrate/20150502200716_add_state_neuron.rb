class AddStateNeuron < ActiveRecord::Migration
  def self.up
    add_column :neurons, :state, :integer, default: 0
  end

  def self.down
    remove_column :neurons, :state
  end
end
