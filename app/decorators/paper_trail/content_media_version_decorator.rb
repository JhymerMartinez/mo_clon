module PaperTrail
  class ContentMediaVersionDecorator < VersionDecorator
    def initialize(*args)
      super(*args)
      ignore_keys "content_id"
      mandatory_keys "media"
    end

    private

    def localised_attr_for(key)
      t("activerecord.attributes.content.#{key}")
    end
  end
end
