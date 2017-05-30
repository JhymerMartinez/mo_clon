module AdminHelper
  ###
  # will create a navbar item and add `active` class if `controller_name`
  # matches current controller
  #
  # @param name [String] keypath to I18n translation
  #   to display on link
  # @param path [String, Object] href path
  # @param controller_name [String] name to match with current controller's
  #   name to know if a nav_item should be `active`. Uses regexp
  # @param options [Object] options passed to `ActionView::Helpers::UrlHelper#link_to`
  # @return [Object] `li` tag with (or without) `active` class with a link
  def nav_item(name, path, controller_name=name, *options)
    active = controller.send(:nav_item) =~ Regexp.new(controller_name, Regexp::IGNORECASE)
    content_tag :li, class: "#{'active' if active}" do
      link_to(
        I18n.t("views.main_navbar.#{name}"),
        path,
        *options
      )
    end
  end
end
