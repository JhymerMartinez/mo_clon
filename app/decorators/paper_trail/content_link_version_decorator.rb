module PaperTrail
  class ContentLinkVersionDecorator < VersionDecorator
    def initialize(*args)
      super(*args)
      ignore_keys "content_id"
      mandatory_keys "link"
    end

    private

    def localised_attr_for(key)
      t("activerecord.attributes.content_link.#{key}")
    end
  end
end
