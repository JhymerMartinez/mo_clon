module Api
  class TreeNeuronSerializer < ActiveModel::Serializer
    root false

    ATTRIBUTES = TreeService::UserTreeFetcher::ATTRIBUTES + [
      :children,
      :state
    ].freeze

    attributes *ATTRIBUTES

    def state
      if current_user.already_learnt_any?(object.contents)
        "florecida"
      else
        "descubierta"
      end
    end

    def children
      @children
    end

    def children=(new_children)
      @children = new_children
    end

    alias_method :current_user, :scope
  end
end
