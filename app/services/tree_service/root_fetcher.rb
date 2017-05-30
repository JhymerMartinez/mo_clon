module TreeService
  class RootFetcher
    def self.root_neuron
      @@root_neuron ||= Neuron.first
    end
  end
end
