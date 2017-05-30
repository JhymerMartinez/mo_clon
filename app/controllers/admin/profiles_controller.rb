module Admin
  class ProfilesController < AdminController::Base
    include Breadcrumbs

    before_action :add_breadcrumbs

    authorize_resource

    expose(:profiles)
    expose(:profile, attributes: :profile_params)
    expose(:decorated_profile) {
      decorate profile
    }
    alias_method :resource, :decorated_profile

    expose(:root_neuron) {
      TreeService::RootFetcher.root_neuron
    }

    expose(:initial_neurons) {
      TreeService::ByDepthFetcher.new(
        depth: 2,
        scope: decorated_profile.neurons
      ).neurons
    }

    def create
      profile.user = current_user
      if profile.save
        redirect_to admin_profile_path(profile)
      else
        render :new
      end
    end

    def show
      respond_to do |format|
        format.html
        format.json {
          render json: decorated_profile.neurons,
                 root: "neurons",
                 meta: { root_id: root_neuron.id,
                         initial_tree: initial_neurons.map(&:id) }
        }
      end
    end

    def edit
      respond_to do |format|
        format.html
        format.json {
          render json: decorated_profile.all_neurons,
                 root: "neurons",
                 meta: { root_id: root_neuron.id,
                         initial_tree: decorated_profile.neurons.map(&:id) }
        }
      end
    end

    def update
      if profile.save
        redirect_to(
          { action: :show, id: profile.id },
          notice: I18n.t("views.profiles.updated")
        )
      else
        render :edit
      end
    end

    private

    def profile_params
      params.require(:profile)
            .permit(
              :name,
              :biography,
              :neuron_ids
            )
    end

    def breadcrumb_base
      "profile"
    end
  end
end
