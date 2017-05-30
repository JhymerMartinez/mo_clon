module TreeService
  class ContentsForTestFetcher
    MIN_CONTENTS_PER_NEURON = 4

    def initialize(user)
      @user = user
    end

    def contents
      content_ids = [
        grouped_content_reading_ids_for_test,
        flourished_neurons_content_reading_ids_for_test
      ].flatten.compact
      Content.where(
        id: content_ids
      ).where.not(
        id: learnings.pluck(:content_id)
      )
    end

    private

    def grouped_content_reading_ids_for_test
      readings.where.not(
        id: learnings.pluck(:content_id)
      ).group(:neuron_id).count.map do |neuron_id, count|
        if count >= MIN_CONTENTS_PER_NEURON
          readings.where(
            neuron_id: neuron_id
          ).pluck(:content_id)
        end
      end.flatten.compact
    end

    def flourished_neurons_content_reading_ids_for_test
      readings.where(
        content_id: flourished_neurons_children_content_ids
      ).pluck(:content_id)
    end

    def flourished_neurons_children_content_ids
      neuron_ids = [
        flourished_neurons_ids,
        flourished_neurons_children_ids
      ].flatten.compact
      Content.where(
        neuron_id: neuron_ids
      ).pluck(:id)
    end

    def flourished_neurons_children_ids
      Neuron.where(
        parent_id: flourished_neurons_ids
      ).pluck(:id)
    end

    def flourished_neurons_ids
      learnings.pluck(:neuron_id)
    end

    def learnings
      @user.content_learnings
    end

    def readings
      @user.content_readings
    end
  end
end
