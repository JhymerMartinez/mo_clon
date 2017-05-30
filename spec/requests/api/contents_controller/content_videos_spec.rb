require "rails_helper"

RSpec.describe Api::ContentsController,
               type: :request do
  include_examples "requests:current_user"
  include_examples "neurons_controller:approved_content"
  let(:current_user) { create :user }

  subject {
    JSON.parse(response.body).fetch("content")
  }

  describe "includes videos in content" do
    before { login_as current_user }

    let!(:content_video) {
      create :content_video,
             content: content
    }

    describe "url" do
      before { get "/api/neurons/#{neuron.id}/contents/#{content.id}" }

      it {
        expect(
          subject["videos"].first["url"]
        ).to eq(content_video.url)
      }
    end

    describe "thumbnail" do
      let(:response_thumbnail) {
        subject["videos"].first["thumbnail"]
      }

      describe "supported party" do
        let(:video_id) { "VIDEOID" }

        let!(:content_video) {
          create :content_video,
                 content: content,
                 url: "http://youtube.com/?v=#{video_id}"
        }

        let(:thumbnail_url) {
          "//img.youtube.com/vi/#{video_id}/0.jpg"
        }

        before { get "/api/neurons/#{neuron.id}/contents/#{content.id}" }

        it {
          expect(response_thumbnail).to eq(thumbnail_url)
        }
        it {
          expect(response_thumbnail).to include(video_id)
        }
      end

      describe "unsupported party" do
        let!(:content_video) {
          create :content_video,
                 content: content,
                 url: "http://provider.com/?v=id"
        }

        before { get "/api/neurons/#{neuron.id}/contents/#{content.id}" }

        it {
          expect(response_thumbnail).to be_nil
        }
      end
    end
  end
end
