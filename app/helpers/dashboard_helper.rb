module DashboardHelper
  ##
  # Creates a switcher for different neuron states
  # picks states from Neuron model
  #
  # @return [String] tabs for neuron states
  def neuron_state_switcher
    content_tag :div, class: "btn-group" do
      Neuron::STATES.map do |state|
        active = "active" if neuron_scope == state.to_sym
        link_to t("views.neurons.#{state}"),
                admin_root_path(
                  state: state,
                  q: params[:q]
                ),
                class: "btn btn-default #{active}"
      end.join.html_safe
    end
  end
end
