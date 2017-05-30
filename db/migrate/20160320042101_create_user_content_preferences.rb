class CreateUserContentPreferences < ActiveRecord::Migration
  def change
    create_table :user_content_preferences do |t|
      t.references :user,
                   null: false,
                   index: true,
                   foreign_key: true
      t.string :kind,
               null: false
      t.integer :level,
                null: false,
                default: 1
      t.timestamps null: false
    end
  end
end
