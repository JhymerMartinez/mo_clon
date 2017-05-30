module PaperTrail
  class ContentVideoVersionDecorator < VersionDecorator
    def initialize(*args)
      super(*args)
      ignore_keys "content_id"
      mandatory_keys "url"
    end

    private

    def localised_attr_for(key)
      t("activerecord.attributes.content_video.#{key}")
    end
  end
end
