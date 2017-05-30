class User < ActiveRecord::Base
  module UserMediaSeen

    def media_seen(media_url)
      user_media = UserSeenImage.where(user_id: self.id, media_url: media_url)
      unless user_media.any?
        user_media = UserSeenImage.new(user_id: self.id, media_url: media_url)
        user_media.save
      end
      user_media
    end
  end
end
