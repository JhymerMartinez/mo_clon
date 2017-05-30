class CreateSearchEngines < ActiveRecord::Migration
  def change
    create_table :search_engines do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.boolean :active, default: true
      t.string :gcse_id, null: false

      t.timestamps null: false
    end
    add_index :search_engines, :slug, unique: true
    add_index :search_engines, :gcse_id, unique: true
  end
end
