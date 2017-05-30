module Admin
  class SettingsController < AdminController::Base
    include Breadcrumbs

    before_action :add_breadcrumbs

    expose(:search_engines) {
      decorate SearchEngine.all
    }

    private

    def breadcrumb_base
      "settings"
    end
  end
end
