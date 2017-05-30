class CreatePossibleAnswers < ActiveRecord::Migration
  def change
    create_table :possible_answers do |t|
      t.references :content, index: true, null: false
      t.string :text, null: false
      t.boolean :correct, default: false
      t.timestamps null: false
    end
    
    add_index :possible_answers, :correct
    add_foreign_key :possible_answers, :contents
  end
end
