class ContentLinkDecorator < LittleDecorator
  def list_group_item
    content_tag :li do
      link_to record.link,
              record.link,
              target: "_blank"
    end
  end
end
