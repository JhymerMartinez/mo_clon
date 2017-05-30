RSpec.shared_examples "neurons_controller:approved_content" do
  let!(:neuron) {
    create :neuron,
           :public,
           :with_approved_content
  }

  let(:content) { neuron.contents.first }

  before {
    # neuron scope will render user's tree.
    # The only way to make sure this neuron
    # is available to the API is making it
    # root, as it'll always be accessible
    # @see Api::BaseController::NeuronScope
    root_neuron(neuron)
  }
end
