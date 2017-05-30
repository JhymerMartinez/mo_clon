require "rails_helper"

RSpec.describe Api::ContentsController,
               type: :request do
  include_examples "requests:current_user"
  include_examples "neurons_controller:approved_content"

  let(:current_user) { create :user }

  subject {
    JSON.parse(response.body).fetch("content")
  }

  describe "includes links in content" do
    before { login_as current_user }

    let!(:content_link) {
      create :content_link,
             content: content
    }

    before {
      get "/api/neurons/#{neuron.id}/contents/#{content.id}"
    }

    it {
      expect(
        subject["links"].first
      ).to include(content_link.link)
    }
  end

end
