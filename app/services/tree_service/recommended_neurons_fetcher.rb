module TreeService
  class RecommendedNeuronsFetcher

    attr_reader :user,
                :neurons,
                :scope,
                :children_fetcher,
                :recommended

    def initialize(options)
      @neurons = []
      @user = options.fetch(:user)
      @scope = PublicScopeFetcher.new(user).neurons
      @children_fetcher = ChildrenIdsFetcher.new(scope)
    end

    def recommended
      fetch_pool!
    end

    private

    def fetch_pool!
      children_fetcher.scope.each do |neuron|
        unless user.already_learnt_any?(neuron.contents)
          neurons << neuron
        end
      end
      neurons
    end

  end
end
