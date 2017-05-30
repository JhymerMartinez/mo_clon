require "rails_helper"

RSpec.describe Api::ContentsController,
               type: :request do
  include_examples "neurons_controller:approved_content"

  let(:current_user) { create :user }

  let(:endpoint) {
    "/api/neurons/#{neuron.id}/contents/#{content.id}/read"
  }

  let(:json_response) {
    JSON.parse response.body
  }

  before { login_as current_user }

  describe "#read not triggering test" do
    before { post endpoint }

    it {
      expect(json_response["perform_test"]).to be_falsey
    }
    it {
      expect(json_response["test"]).to be_nil
    }
  end

  describe "triggering test #read" do
    let(:legacy_readings_count) {
      TreeService::ReadingTestFetcher::MIN_COUNT_FOR_TEST - 1
    }

    let!(:already_read_contents) {
      legacy_readings_count.times.map do
        create :content,
               :approved,
               :with_possible_answers,
               neuron: neuron
      end
    }

    let!(:legacy_readings) {
      already_read_contents.map do |content|
        create :content_reading,
               content: content,
               user: current_user
      end
    }

    before { post endpoint }

    it {
      expect(json_response["perform_test"]).to be_truthy
    }

    it "questions include needed info" do
      %w(
        title
        media_url
        content_id
        possible_answers
      ).each do |key|
        expect(
          json_response["test"]["questions"].first
        ).to have_key(key)
      end
    end

    describe "creates proper test" do
      let(:user_test) {
        current_user.learning_tests.first
      }

      it {
        expect(user_test).to be_present
      }

      it {
        expect(
          user_test.questions.map do |question|
            question["content_id"]
          end
        ).to include(content.id)
      }
    end
  end
end
