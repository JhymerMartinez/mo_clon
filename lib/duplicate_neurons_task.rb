class DuplicateNeuronsTask
  def self.list
    list = DuplicateNeuronsWiper.new.list
    puts list
    puts "#{list.length} neurons"
  end

  def self.wipe_all!
    list = DuplicateNeuronsWiper.new.wipe_all!
    puts list
    puts "#{list.length} neurons wiped"
  end

  class DuplicateNeuronsWiper
    def list
      duplicate_neurons.select(:title).map(&:title)
    end

    def wipe_all!
      list.tap do |list|
        duplicate_neurons.find_each do |neuron|
          neuron.destroy
        end
      end
    end

    private

    def duplicate_neurons
      Neuron.where("title ILIKE :t", t: "%DUP%")
    end
  end
end
