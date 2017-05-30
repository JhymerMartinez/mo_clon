require "rails_helper"

RSpec.describe Admin::DashboardController,
               type: :controller do
  describe "Active and Inactive neurons" do
    let!(:current_user) {
      create :user, :admin
    }

    # default neuron state is active
    let!(:active_neuron) { create :neuron, active: true}

    let!(:inactive_neuron) { create :neuron }

    before {
      sign_in current_user
    }

    describe "should get active neuron" do
      before {
        get :index, state: 'active'
      }

      it {
        expect(controller.neurons).to include(active_neuron)
      }
    end

    describe "should get inactive neuron" do
      before {
        get :index, state: 'inactive'
      }

      it {
        expect(controller.neurons).to include(inactive_neuron)
      }
    end

    describe "empty params" do
      before {
        get :index, state: ""
      }

      it "uses default scope" do
        expect(controller.neurons).to include(active_neuron)
      end
    end
  end
end
