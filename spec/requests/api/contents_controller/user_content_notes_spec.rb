require "rails_helper"

RSpec.describe Api::ContentsController,
               type: :request do
  include_examples "requests:current_user"
  include_examples "neurons_controller:approved_content"

  let(:current_user) { create :user }

  subject {
    JSON.parse(response.body).fetch("content")
  }

  describe "includes user notes in content" do
    before { login_as current_user }

    let!(:content_note) {
      create :content_note,
             content: content,
             user: current_user
    }

    before {
      get "/api/neurons/#{neuron.id}/contents/#{content.id}"
    }

    it {
      expect(
        subject["user_notes"]
      ).to eq(content_note.note)
    }
  end
end
