module RootNeuronMockable
  def root_neuron(neuron)
    TreeService::RootFetcher.class_variable_set(
      :@@root_neuron,
      neuron
    )
    neuron
  end
end
