require "rails_helper"

describe SpellcheckDecorator do
  let(:decorator) { described_class.new(content) }
  let(:content) { create :content }

  describe "valid regexp" do
    description = "*.con caracteres) especiales!'\/"

    subject { regexp }

    description.split(" ").each do |word|
      describe "word #{word}" do
        let(:regexp) {
          decorator.send :regexp_for, word
        }

        it { is_expected.to match(" #{word} ") }
        it { is_expected.to match(" #{word.upcase} ") }
      end
    end
  end
end
