require "uri"
require "cgi"

class ContentVideoDecorator < LittleDecorator
  def list_group_item
    if record.supported_party?
      embedded
    else
      record.url_without_schema
    end
  end

  def embedded
    content_tag(
      :iframe,
      nil,
      src: record.embedded_url,
      width: 560,
      height: 315,
      frameborder: 0,
      allowfullscreen: :allowfullscreen
    )
  end
end
