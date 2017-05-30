module Admin
  class SearchEnginesController < SettingsController
    expose(:search_engine) {
      if params[:id].present?
        SearchEngine.find params[:id]
      else
        SearchEngine.new search_engine_params
      end
    }
    expose(:decorated_search_engine) {
      decorate search_engine
    }

    authorize_resource

    def create
      if search_engine.save
        redirect_to admin_settings_path,
                    notice: I18n.t("views.search_engine.created")
      else
        render :new
      end
    end

    def update
      if search_engine.update(search_engine_params)
        redirect_to admin_settings_path,
                    notice: I18n.t("views.search_engine.updated")
      else
        render :edit
      end
    end

    private

    def nav_item
      "settings"
    end

    def search_engine_params
      params.require(:search_engine)
            .permit(:name, :slug, :gcse_id, :active)
    rescue ActionController::ParameterMissing
      Hash.new
    end

    def add_breadcrumbs
      breadcrumb_for "index"
      send "breadcrumb_for_#{action_name}"
    end

    def breadcrumb_for_index
      add_breadcrumb(
        I18n.t("views.search_engines")
      )
    end

    def breadcrumb_for_show
      add_breadcrumb search_engine
    end

    alias_method :breadcrumb_for_create,
                 :breadcrumb_for_show

    def breadcrumb_for_edit
      add_breadcrumb search_engine,
                     admin_search_engine_path(search_engine)
      add_breadcrumb I18n.t("actions.edit")
    end

    alias_method :breadcrumb_for_update,
                 :breadcrumb_for_edit

    def breadcrumb_for_new
      add_breadcrumb I18n.t("actions.new")
    end
  end
end
