module Tutor
  module TutorController
    class Base < ::ApplicationController
      layout "tutor"

      before_action :authenticate_user!
      before_action :restrict_cliente!
      before_action :restrict_admin!

      private

      def restrict_cliente!
        redirect_to(
          root_path,
          error: I18n.t("views.unauthorized")
        ) if current_user.cliente?
      end

      def restrict_admin!
        redirect_to(
          admin_root_path
        ) if current_user.admin?
      end
    end
  end
end
