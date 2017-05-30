module Admin
  module Breadcrumbs
    extend ActiveSupport::Concern
    ##
    # Adds breadcrumbs for each action.
    # Calls breadcrumbs for #index by default
    def add_breadcrumbs
      breadcrumb_for "index" # base

      breadcrumb_for action_name unless action_name == "index"
    end

    ##
    # @return [String] base name (singular)
    #   based on controller's name by default
    def breadcrumb_base
      controller_name.singularize
    end

    def breadcrumbs_plural
      breadcrumb_base.pluralize
    end

    ##
    # @return [String] base path to
    #   generate links
    def breadcrumbs_base_path
      breadcrumb_base
    end

    ##
    # @param action [String] name of the action
    #   to render breadcrumbs for
    def breadcrumb_for(action)
      case action
      when "index"
        add_breadcrumb(
          I18n.t(
            "activerecord.models.#{breadcrumb_base}"
          ).pluralize,
          send("admin_#{breadcrumbs_base_path.pluralize}_path")
        )
      when "new"
        add_breadcrumb(
          I18n.t(
            "views.#{breadcrumbs_plural}.new"
          ),
          send("new_admin_#{breadcrumbs_base_path}_path")
        )
      when "create"
        breadcrumb_for "new"
      when "show"
        add_breadcrumb(
          resource,
          send("admin_#{breadcrumbs_base_path}_path", resource)
        )
      when "edit"
        breadcrumb_for "show"

        add_breadcrumb(
          I18n.t("views.#{breadcrumb_base.pluralize}.edit"),
          send("edit_admin_#{breadcrumbs_base_path}_path")
        )
      when "update"
        breadcrumb_for "edit"
      end

      # define breadcrumb_for_action for custom
      if respond_to?("breadcrumb_for_#{action}", true)
        send("breadcrumb_for_#{action}")
      end
    end
  end
end
