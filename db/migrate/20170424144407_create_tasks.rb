class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :user, index: true, null: false
      t.references :content, index: true, null: false
      t.timestamps null: false
    end
  end
end
