require 'rails_helper'

RSpec.describe SpellingAnalysisWorker do
  let(:lang) { "es" }
  let(:description) {
    "texto con herror"
  }
  let!(:content) { create :content }
  let(:description_analysis) {
    content.spellcheck_analyses.for(:description).first
  }
  let(:worker) {
    SpellingAnalysisWorker.new(content)
  }

  let(:mock_spellcheck) {
    expect(
      Spellchecker
    ).to receive(:check).with(
      description,
      lang
    )
  }

  let(:run_worker!) {
    content.description = description
    content.spellcheck_analyses.for(:description).destroy_all # mimic schedule

    expect {
      worker.perform
    }.to change {
      SpellcheckAnalysis.count
    }.by(1)
  }

  context "success" do
    let(:spellcheck_result) {
      [
        { original: "texto", correct: true },
        { original: "con", correct: true },
        { original: "herror",
          correct: false,
          suggestions: ["herrar", "herir", "error"] }
      ]
    }

    before {
      mock_spellcheck.and_return(
        spellcheck_result
      )
      run_worker!
    }

    it {
      expect(description_analysis).to be_success
    }

    it {
      expect(
        description_analysis.words.length
      ).to eq(1)
    }

    it {
      expect(
        description_analysis.words.first["original"]
      ).to eq("herror")
    }

    it {
      expect(
        description_analysis.words.first["suggestions"]
      ).to include("error")
    }

    it {
      expect(
        description_analysis.words.first
      ).to_not have_key("correct")
    }
  end

  context "failures" do
    describe "known exception" do
      before {
        mock_spellcheck.and_raise(
          Errno::ENOENT,
          "aspell"
        )
        run_worker!
      }

      it {
        expect(description_analysis).to_not be_success
      }
    end

    describe "unknown exception" do
      before {
        mock_spellcheck.and_raise(
          RuntimeError,
          "Something bad happened"
        )
      }

      it {
        expect {
          run_worker!
        }.to raise_error(RuntimeError)
      }
    end
  end
end
