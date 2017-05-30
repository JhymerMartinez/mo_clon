class CreateNeurons < ActiveRecord::Migration
  def change
    create_table :neurons do |t|
      t.string :title, null: false
      t.integer :parent_id

      t.timestamps null: false
    end
    add_index :neurons, :parent_id
    add_index :neurons, :title
  end
end
