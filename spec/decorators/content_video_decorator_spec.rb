require "rails_helper"

describe ContentVideoDecorator do
  describe "#url" do
    let(:video) {
      create :content_video,
             url: url
    }

    subject { described_class.new(video) }

    describe "removes protocol if url" do
      let(:url) { "http://domain.com" }
      it {
        expect(
          subject.send(:list_group_item)
        ).to eq("//domain.com")
      }
    end

    describe "fallback to original" do
      let(:url) { "bla bla bla" }
      it {
        expect(
          subject.send(:list_group_item)
        ).to eq(url)
      }
    end

    describe "enhances youtube videos" do
      let(:youtube_id) {
        "SDDC44CCK9NP5gizE"
      }
      let(:url) {
        "https://www.youtube.com/watch?b=2&a=1&v=#{youtube_id}"
      }
      let(:embedded_url) {
        "//www.youtube.com/embed/#{youtube_id}"
      }
      it {
        expect(
          subject.send(:embedded_url)
        ).to eq(embedded_url)
      }
    end
  end
end
