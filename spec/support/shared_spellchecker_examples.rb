RSpec.shared_examples "spellchecker examples" do
  describe "schedules spelling analysis" do
    before {
      expect(
        SpellingAnalysisWorker
      ).to receive(:new).with(resource).and_call_original
    }

    it {
      resource.update_attribute tracked_attribute,
                                attributes.fetch(tracked_attribute)
    }
  end

  describe "does not schedule spelling analysis if nothing analised changed" do
    before {
      expect(
        SpellingAnalysisWorker
      ).not_to receive(:new)
    }

    it {
      resource.update_attribute untracked_attribute,
                                attributes.fetch(untracked_attribute)
    }
  end
end
