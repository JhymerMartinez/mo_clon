class CreateContentNotes < ActiveRecord::Migration
  def change
    create_table :content_notes do |t|
      t.references :content,
                   null: false,
                   index: true,
                   foreign_key: true
      t.references :user,
                   null: false,
                   index: true,
                   foreign_key: true
      t.text :note,
             null: false

      t.timestamps null: false
    end
  end
end
