module Api
  module Users
    class RecommendedNeuronsController < BaseController
      before_action :authenticate_user!

      respond_to :json

      expose(:user) {
        current_user
      }

      api :GET,
          "/users/recommended_neurons",
          "recommended neurons from user's tree"

      def show
        respond_with recommended_neurons,
                      root: :neurons
      end

      private

      def recommended_neurons
        TreeService::RecommendedNeuronsFetcher.new(
          user: current_user,
        ).recommended
      end
    end
  end
end
