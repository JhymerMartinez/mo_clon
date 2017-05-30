module Admin
  class UsersController < AdminController::Base
    include Breadcrumbs

    before_action :add_breadcrumbs

    authorize_resource

    expose(:user, attributes: :user_params)
    expose(:users)
    expose(:roles) {
      User::Roles::ROLES
    }
    expose(:decorated_user) {
      decorate user
    }

    def index
      respond_to do |format|
        format.html
        format.json {
          render json: UsersDatatable.new(view_context)
        }
      end
    end

    def create
      if user.save
        redirect_to admin_users_path, notice: I18n.t("views.users.created")
      else
        render :new
      end
    end

    def update
      if user.save
        redirect_to admin_users_path, notice: I18n.t("views.users.updated")
      else
        render :edit
      end
    end

    private

    def user_params
      params.require(:user).permit(*permitted_attributes)
    end

    def permitted_attributes
      allowed = [:name, :email, :role]
      if params[:user][:password].present?
        allowed += [:password, :password_confirmation]
      end
      allowed
    end

    def resource
      @resource ||= user
    end
  end
end
