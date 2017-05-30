class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.integer :level, null: false
      t.string :kind, null: false
      t.text :description, null: false
      t.references :neuron, index: true, null: false
      t.timestamps null: false
    end
  end
end
