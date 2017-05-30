class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name
      t.text :biography
      t.references :user, index: true, null: false
      t.text :neuron_ids, array: true, default: []

      t.timestamps null: false
    end
    add_foreign_key :profiles, :users
  end
end
