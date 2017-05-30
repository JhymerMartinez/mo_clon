module TreeService
  class LearntNeuronsFetcher
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def ids
      @neuron_ids ||= contents.select(:neuron_id)
                              .map(&:neuron_id)
    end

    private

    def contents
      Content.where(id: content_ids)
    end

    def learnings
      user.content_learnings
          .includes(:content)
    end

    def content_ids
      learnings.select(:content_id)
               .map(&:content_id)
    end
  end
end
