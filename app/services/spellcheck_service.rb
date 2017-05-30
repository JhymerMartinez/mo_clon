class SpellcheckService
  attr_reader :words

  SUGGESTIONS = 3
  LANG = I18n.locale.to_s
  RESCUED_EXCEPTIONS = {
    RuntimeError => [
      "Aspell command not found"
    ],
    Errno::ENOENT => [
      "No such file or directory - aspell"
    ]
  }

  def initialize(text)
    @text = text
    analyse!
  end

  def success?
    @success
  end

  private

  ##
  # rescues when aspell is not present
  def analyse!
    @words = formatted_mispelled_words
    @success = true
  rescue *rescued_exceptions_keys => e
    @success = false
    if rescued_exceptions_messages.include?(e.message)
      # aspell is not present. track analysis as failure
    else
      raise e
    end
  end

  ##
  # store a limited ammount of suggestions
  # and discard :correct property
  def formatted_mispelled_words
    mispelled_words.map do |word|
      {
        original: word[:original],
        suggestions: word[:suggestions].first(SUGGESTIONS) # or .sample(3)
      }
    end
  end

  ##
  # call spellchecker and reject correct
  # words
  def mispelled_words
    Spellchecker.check(@text, LANG).reject do |word|
      word[:correct]
    end
  end

  def rescued_exceptions_keys
    RESCUED_EXCEPTIONS.keys
  end

  def rescued_exceptions_messages
    RESCUED_EXCEPTIONS.values.flatten
  end
end
