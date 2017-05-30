module Admin
  class ContentsController < AdminController::Base
    authorize_resource

    expose(:content)

    def approve
      content.toggle! :approved
      redirect_to admin_neuron_path(content.neuron),
                  notice: t("views.contents.toggled_approve.#{content.approved}")
    end
  end
end
