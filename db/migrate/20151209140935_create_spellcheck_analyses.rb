class CreateSpellcheckAnalyses < ActiveRecord::Migration
  def change
    create_table :spellcheck_analyses do |t|
      t.string :attr_name, null: false
      t.json :words, default: []
      t.integer :analysable_id, null: false
      t.string :analysable_type, null: false

      t.timestamps null: false
    end

    add_index :spellcheck_analyses,
              [:analysable_id, :analysable_type]
  end
end
