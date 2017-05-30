require "rails_helper"

RSpec.describe Api::LearnController,
               type: :request do
  let!(:user_test) {
    create :content_learning_test,
           user: current_user
  }
  let(:current_user) {
    create :user
  }

  let(:endpoint) {
    "/api/learn"
  }

  before { login_as current_user }

  let(:json_response) {
    JSON.parse response.body
  }

  let(:params) {
    {
      test_id: user_test.id,
      answers: response_answers.to_json
    }
  }

  let(:response_answers) {
    valid_count = 0
    user_test.questions.map do |question|
      {
        content_id: question["content_id"],
        answer_id: question["possible_answers"].detect { |possible_answer|
          if valid_count < 3
            valid_count += 1
            possible_answer["correct"]
          end
        }.try(:fetch, "id")
      }
    end
  }

  describe "creates learning" do
    before {
      expect {
        post endpoint, params
      }.to change {
        current_user.learned_contents.count
      }.by(3) # learning only 3
    }

    it "answer contains content ids and result" do
      response_answers.each do |answer|
        expect(
          json_response["result"].detect do |result|
            result["content_id"] == answer[:content_id]
          end
        ).to be_present
      end
    end

    it "learns only valid contents" do
      expect(
        json_response["result"].select { |result|
          result["correct"]
        }.count
      ).to eq(3)
    end
  end

  describe "already answered test" do
    before {
      user_test.update! completed: true
    }

    it {
      expect {
        post endpoint, params
      }.to raise_error(ActiveRecord::RecordNotFound)
    }
  end
end
