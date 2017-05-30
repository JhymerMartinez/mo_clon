module Admin
  class DashboardController < AdminController::Base

    expose(:neurons) {
      NeuronAdminSearch.new(
        q: params[:q]
      ).results
       .send(neuron_scope)
       .accessible_by(current_ability, :index)
       .page(params[:page]).per(18)
    }
    expose(:decorated_neurons) {
      decorate neurons
    }

    expose(:neuron_scope) {
      raise ActiveRecord::RecordNotFound unless Neuron::STATES.include?(state)
      state.to_sym
    }

    private

    def state
      params[:state].present? ? params[:state] : "active"
    end
  end
end
