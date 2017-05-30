module PaperTrail
  class Version < ::ActiveRecord::Base
    scope :reverse, -> {
      scoped.merge(
        unscope(:order)
      ).order(id: :desc)
    }
  end
end
