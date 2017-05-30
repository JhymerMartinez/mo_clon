module TreeService
  class SortingService
    def self.sort_neurons!(tree)
      neurons = tree.first
      neurons.each do |neuron|
        new(neuron).perform!
      end
    end

    attr_reader :neuron

    def initialize(neuron)
      @neuron = neuron
    end

    def perform!
      update_children!
    end

    private

    def update_children!
      children.each do |child|
        new_position = sorted_children_ids.index(child["id"])
        child_neuron = Neuron.find(child["id"])
        child_neuron.update_column(
          :parent_id,
          neuron["id"]
        ) unless child_neuron.parent_id == neuron["id"]
        child_neuron.update_column(
          :position,
          new_position
        ) unless child_neuron.position == new_position

        self.class.new(child).perform!
      end
    end

    def children
      neuron["children"].first
    end

    def sorted_children_ids
      @sorted_children_ids ||= children.map do |child|
        child["id"]
      end
    end
  end
end
