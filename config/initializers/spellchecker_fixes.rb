module Spellchecker

  # Builds a response (a hash) from the raw output from Aspell.
  #
  # Example:
  #
  # Takes Aspell output from the command:
  #
  #     echo "test textZ" | aspell -a -l en
  #
  # ... resulting in:
  #
  #     @(#) International Ispell Version 3.1.20 (but really Aspell 0.60.6.1)
  #     *
  #     & textZ 3 11: texts, text, text's
  #
  # ... and builds a response (hash) that looks like:
  #
  #    [
  #      {original: text, correct: true  },
  #      {original: textZ, correct: false, suggestions: [ texts, text, text's] }
  #    ]
  #
  class BuildResponse
    ASPELL_WORD_DATA_REGEX = Regexp.new(/\&\s\w+\s\d+\s\d+(.*)$/)

    def initialize(text, command_output)
      @text, @command_output = text, command_output
    end

    def call
      response     = extract_original_string_tokens(text)
      results      = extract_results(command_output)

      build_response_from_results(response, results)

      response
    end

    private

    attr_reader :text, :command_output

    def extract_original_string_tokens(text)
      text.split(' ').collect { |original| {:original => original} }
    end

    def extract_results(command_output)
      command_output.split("\n").slice(1..-1)
    end

    def build_response_from_results(response, results)
      response.each_with_index do |word_hash, index|
        element = build_response_element(word_hash[:original], results, index)
        response[index].merge!(element)
      end
    end

    def build_response_element(original_word, results, result_index)
      if !valid_word?(original_word)
        return build_response_element_with_correct_spelling
      end

      element = if correct_spelling?(results[result_index])
        build_response_element_with_correct_spelling
      else
        build_response_element_with_suggestions(results[result_index])
      end

      element
    end

    def valid_word?(word)
      word =~ /[a-zA-z\[\]\?]/
    end

    def correct_spelling?(result_line)
      !(result_line =~ ASPELL_WORD_DATA_REGEX)
    end

    def build_response_element_with_correct_spelling
      {:correct => true}
    end

    def build_response_element_with_suggestions(result_line)
      suggestions = extract_suggestions(result_line)
      {:correct => false, :suggestions => suggestions}
    end

    def extract_suggestions(result_line)
      result_line.split(':')[1].strip.split(',').map(&:strip)
    end
  end
end
