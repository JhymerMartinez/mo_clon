class UpdateUserSeenImages < ActiveRecord::Migration
  def change
    create_table :user_seen_images do |t|
      t.references :user, index: true, null: false
      t.string :media_url, null: false
      t.timestamps null: false
    end
  end
end
