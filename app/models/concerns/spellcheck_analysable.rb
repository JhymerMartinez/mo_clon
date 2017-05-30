module SpellcheckAnalysable
  extend ActiveSupport::Concern

  included do
    # relationships
    has_many :spellcheck_analyses,
             as: :analysable,
             dependent: :destroy

    # callbacks
    before_save :expire_spellcheck_analysis!
    after_save :schedule_spellcheck_analysis!
  end

  private

  ##
  # destroys spelling analysis records
  # for dirty attributes
  def expire_spellcheck_analysis!
    spellcheck_attributes.each do |attribute|
      if send("#{attribute}_changed?")
        spellcheck_analyses.for(
          attribute
        ).destroy_all
      end
    end
  end

  ##
  # schedules a spellcheck analysis if
  # there's any attribute missing without
  # analysis
  def schedule_spellcheck_analysis!
    if missing_spellcheck_analysis?
      self.class.delay.perform_spellcheck!(id)
    end
  end

  def missing_spellcheck_analysis?
    spellcheck_analyses.count != filtered_spellcheck_attributes.count
  end

  ##
  # @note rejects blanks
  def filtered_spellcheck_attributes
    spellcheck_attributes.reject do |attribute|
      send(attribute).blank?
    end
  end

  def spellcheck_attributes
    self.class::SPELLCHECK_ATTRIBUTES
  end

  module ClassMethods
    def perform_spellcheck!(id)
      resource = find(id)
      SpellingAnalysisWorker.new(resource).perform
    end
  end
end
