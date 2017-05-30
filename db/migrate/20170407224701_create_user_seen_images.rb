class CreateUserSeenImages < ActiveRecord::Migration
  def change
    create_table :user_seen_images do |t|
      t.references :user, index: true, null: false
      t.references :content_media, index: true, null: false
      t.timestamps null: false
    end
  end
end
