class SpellingAnalysisWorker
  attr_reader :resource

  def initialize(resource)
    @resource = resource
  end

  def perform
    attributes_to_analyse.each do |attribute|
      text = resource.send(attribute)
      create_analysis!(attribute, text) if text.present?
    end
  end

  private

  ##
  # creates spellcheck analysis
  def create_analysis!(attribute, text)
    analysis = SpellcheckService.new(text)
    resource.spellcheck_analyses.create!(
      attr_name: attribute,
      words: analysis.words,
      success: analysis.success?
    )
  end

  ##
  # we'll only analyse attributes that
  # have changed
  def attributes_to_analyse
    resource.send(:spellcheck_attributes) - resource.spellcheck_analyses.pluck(:attr_name)
  end
end
