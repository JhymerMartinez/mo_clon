require "content"

class OldContentMediaUploader < CarrierWave::Uploader::Base
  def store_dir
    "uploads/content/media/#{model.id}"
  end
end

class Content < ActiveRecord::Base
  mount_uploader :media, OldContentMediaUploader
end

class CreateContentMedia < ActiveRecord::Migration
  def up
    create_table :content_media do |t|
      t.string :media
      t.references :content, index: true, foreign_key: true
      t.timestamps null: false
    end

    say_with_time "migrating media" do
      Content.where.not(media: nil).find_each do |content|
        if content.media?
          content.content_medium.create!(
            remote_media_url: content.media_url
          )
          content.update! remove_media: true
        else
          say "[404] #{content.media}"
        end
      end
    end
  end

  def down
    ContentMedia.find_each do |content_media|
      content = content_media.content
      content.update!(
        remote_media_url: content_media.media_url
      )
    end

    drop_table :content_media
  end
end
