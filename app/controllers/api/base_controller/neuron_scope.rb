module Api
  class BaseController < ::ApplicationController
    module NeuronScope
      extend ActiveSupport::Concern

      included do
        expose(:neuron) {
          id = params[:neuron_id] || params[:id]
          Neuron.find(id)
        }
        expose(:neuron_scope) {
          TreeService::PublicScopeFetcher.new(current_user)
        }
        expose(:neurons) {
          neuron_scope.neurons
                      .includes(:contents)
        }
      end
    end
  end
end
