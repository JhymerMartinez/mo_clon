module TreeService
  class RecommendedContentsFetcher
    COUNT = 4

    attr_reader :user, :neuron, :kind, :contents_pool

    def initialize(options)
      @contents_pool = []
      @user = options.fetch(:user)
      @kind = options.fetch(:kind)
      @neuron = options.fetch(:neuron)
      @remaining_levels = Content::LEVELS.dup
    end

    def contents
      fetch_pool!
      contents_pool
    end

    private

    def fetch_pool!
      return if contents_pool.any?
      preferred_level = @remaining_levels.delete(preference.level)
      pool_contents!(
        level: preferred_level,
        count: COUNT
      )
      # keep adding contents to pool if there's
      # not enough
      missing = COUNT - contents_pool.count
      while missing > 0 && @remaining_levels.any?
        level = @remaining_levels.slice!(0)
        pool_contents!(
          level: level,
          count: missing
        )
      end
    end

    def pool_contents!(options = {})
      @contents_pool += contents_scope.where(
        level: options.fetch(:level)
      ).limit(
        options.fetch(:count)
      )
    end

    def contents_scope
      Content.approved
             .with_media
             .where(
               kind: kind,
               neuron_id: neuron.children_neurons.pluck(:id)
             )
    end

    def preference
      user.content_preferences.by_kind(kind)
    end
  end
end
