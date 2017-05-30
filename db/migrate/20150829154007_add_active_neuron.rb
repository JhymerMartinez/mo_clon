class AddActiveNeuron < ActiveRecord::Migration
  def up
    add_column :neurons, :active, :boolean, default: false
  end

  def down
    remove_column :neurons, :active
  end
end
