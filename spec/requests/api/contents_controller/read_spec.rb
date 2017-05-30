require "rails_helper"

RSpec.describe Api::ContentsController,
               type: :request do
  include_examples "neurons_controller:approved_content"

  let(:current_user) { create :user }

  let(:endpoint) {
    "/api/neurons/#{neuron.id}/contents/#{content.id}/read"
  }

  describe "#read" do
    before { login_as current_user }

    before {
      expect { post endpoint }.to change {
        current_user.read_contents.count
      }.by(1)
    }

    it {
      expect(response).to have_http_status(:created)
      expect(
        current_user.read_contents
      ).to include(content)
    }
  end

  describe "unauthenticated #read" do
    before { post endpoint }

    it {
      expect(response).to have_http_status(:unauthorized)
    }
  end

  describe "already read #read" do
    let!(:reading) {
      create :content_reading,
             content: content,
             user: current_user
    }

    before { login_as current_user }

    before {
      expect { post endpoint }.to_not change {
        current_user.read_contents.count
      }
    }

    it {
      expect(response).to have_http_status(:unprocessable_entity)
    }
  end
end
