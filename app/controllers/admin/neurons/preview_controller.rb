module Admin
  module Neurons
    class PreviewController < BaseController
      before_action :add_breadcrumbs

      expose(:neuron) {
        if existing_neuron?
          Neuron.find params[:neuron][:id]
        else
          Neuron.new
        end
      }

      def preview
        authorize! :preview, neuron

        neuron.eager_contents!
        neuron.assign_attributes(neuron_params)

        render "admin/neurons/show"
      end

      private

      def existing_neuron?
        params[:neuron][:id].present?
      end

      def breadcrumb_for_preview
        add_breadcrumb I18n.t("actions.preview")
      end
    end
  end
end
