require "rails_helper"

RSpec.describe Api::RecommendedContentsController,
               type: :request do
  include CollectionExpectationHelpers

  let!(:user) { create :user }
  let(:kind) { Content::KINDS.sample }
  let(:neuron) {
    create :neuron,
           :public,
           :with_content
  }
  let(:child) {
    create :neuron,
           :public,
           parent: neuron
  }
  let(:endpoint) {
    "/api/neurons/#{neuron.id}/recommended_contents/#{kind}"
  }

  # user must have learnt parent neuron
  # to have access to children neurons
  let!(:learning) {
    create :content_learning,
           user: user,
           content: neuron.contents.first
  }

  let(:contents) {
    JSON.parse(response.body).fetch("contents")
  }

  before {
    # endpoint requires authentication
    login_as user
  }

  describe "scope" do
    describe ":approved flag" do
      let!(:approved_content) {
        create :content,
               :approved,
               :with_media,
               kind: kind,
               neuron: child
      }
      let!(:unapproved_content) {
        create :content,
               :with_media,
               kind: kind,
               neuron: child
      }

      before { get endpoint }

      it "includes children neuron's approved content" do
        expect_to_see_in_collection(approved_content)
      end

      it "doesn't include children neuron's unapproved content" do
        expect_to_not_see_in_collection(unapproved_content)
      end
    end

    describe ":with_media" do
      let!(:content_with_media) {
        create :content,
               :approved,
               :with_media,
               kind: kind,
               neuron: child
      }
      let!(:content_without_media) {
        create :content,
               :approved,
               kind: kind,
               neuron: child
      }

      before { get endpoint }

      it "we only recommend contents with media" do
        expect_to_see_in_collection(content_with_media)
      end

      it "doesn't include content without media" do
        expect_to_not_see_in_collection(content_without_media)
      end
    end
  end

  describe "kind" do
    let!(:same_kind_contents) {
      count = TreeService::RecommendedContentsFetcher::COUNT
      1.upto(count).map do
        create :content,
               :approved,
               :with_media,
               kind: kind,
               neuron: child
      end
    }

    let!(:other_content) {
      other_kind = (Content::KINDS - Array(kind)).sample
      create :content,
             :approved,
             :with_media,
             kind: other_kind,
             neuron: child
    }

    before { get endpoint }

    it "includes contents of same kind" do
      same_kind_contents.each do |content|
        expect_to_see_in_collection(content)
      end
    end

    it "doesn't include content of another kind" do
      expect_to_not_see_in_collection(other_content)
    end
  end

  describe "when not enough of same kind" do
    # ATM we only serve of same kind
  end

  describe "priority based on user's content preferences" do
    let!(:user_preferences) {
      # destroy default prefs
      user.content_preferences.destroy_all
      create :user_content_preference,
             user: user,
             kind: kind,
             level: 2
    }

    let!(:preferred_contents) {
      2.times.map do
        create :content,
               :approved,
               :with_media,
               kind: kind,
               neuron: child,
               level: user_preferences.level
      end
    }

    let!(:second_prio_content) {
      create :content,
             :approved,
             :with_media,
             kind: kind,
             neuron: child,
             level: user_preferences.level - 1
    }

    let!(:low_prio_content) {
      create :content,
             :approved,
             :with_media,
             kind: kind,
             neuron: child,
             level: user_preferences.level + 1
    }

    before { get endpoint }

    it "preferred_contents have priority" do
      priority_contents = contents.first(2)
      preferred_contents.each do |content|
        expect_to_see_in_collection(content, priority_contents)
      end
    end

    it "second priority" do
      expect(
        contents[2]["id"]
      ).to eq(second_prio_content.id)
    end

    it "low priority" do
      expect(
        contents[3]["id"]
      ).to eq(low_prio_content.id)
    end
  end
end
