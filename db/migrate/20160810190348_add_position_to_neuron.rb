class AddPositionToNeuron < ActiveRecord::Migration
  def change
    add_column :neurons, :position, :integer, default: 0
    add_index :neurons, :position
  end
end
