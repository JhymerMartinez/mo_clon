class CreateContentLearnings < ActiveRecord::Migration
  def change
    create_table :content_learnings do |t|
      t.references :user,
                   null: false,
                   index: true,
                   foreign_key: true
      t.references :content,
                   null: false,
                   index: true,
                   foreign_key: true

      t.timestamps null: false
    end
  end
end
