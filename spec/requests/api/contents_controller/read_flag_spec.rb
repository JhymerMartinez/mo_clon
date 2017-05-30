require "rails_helper"

RSpec.describe Api::ContentsController,
               type: :request do
  include_examples "requests:current_user"
  include_examples "neurons_controller:approved_content"

  let(:current_user) { create :user }

  subject {
    JSON.parse(response.body).fetch("content")
  }

  describe "flags" do
    before { login_as current_user }

    describe "not read content" do
      before {
        get "/api/neurons/#{neuron.id}/contents/#{content.id}"
      }

      it {
        expect(
          subject["read"]
        ).to be_falsey
      }
    end

    describe "read content" do
      let!(:reading) {
        create :content_reading,
               content: content,
               user: current_user
      }

      before {
        get "/api/neurons/#{neuron.id}/contents/#{content.id}"
      }

      it {
        expect(
          subject["read"]
        ).to be_truthy
      }
    end

    describe "content can be readed" do
      let!(:reading) {
        create :content_reading,
               content: content,
               user: current_user
      }

      before {
        get "/api/neurons/#{neuron.id}/contents/#{content.id}"
      }

      it {
        expect(
          subject["neuron_can_read"]
        ).to be_truthy
      }
    end
  end
end
