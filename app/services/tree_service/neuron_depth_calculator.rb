module TreeService
  class NeuronDepthCalculator
    def initialize
      # so that we cache the tree
      @pool = {}
    end

    ##
    # @return [Integer] depth
    def for(neuron)
      # cache neuron
      @pool[neuron.id] = neuron
      @depth = 1
      calculate_depth neuron
      @depth
    end

    private

    def calculate_depth(neuron)
      if neuron.parent_id.present?
        @depth += 1
        calculate_depth @pool.fetch(neuron.parent_id)
      end
    end
  end
end
