# == Schema Information
#
# Table name: contents
#
#  id          :integer          not null, primary key
#  level       :integer          not null
#  kind        :string           not null
#  description :text             not null
#  neuron_id   :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  source      :string
#  approved    :boolean          default(FALSE)
#  title       :string
#  media_count :integer          default(0)
#

require 'rails_helper'

RSpec.describe Content, :type => :model do
  let(:content) { build :content }
  let(:neuron) { content.neuron }

  describe "factory" do
    it{ expect(content).to be_valid }
  end

  describe "validates #has_description_media_or_links" do
    subject { content }

    context "with description" do
      before {
        expect(content.content_medium).to be_empty
        expect(content.content_links).to be_empty
        expect(content.description).to be_present
      }
      it { is_expected.to be_valid }
    end

    context "with media" do
      let!(:content) {
        build :content, description: nil
      }
      let!(:build_media) {
        content.content_medium.build(attributes_for :content_media)
      }
      before {
        expect(content.content_medium).to_not be_empty
        expect(content.content_links).to be_empty
        expect(content.description).to_not be_present
      }
      it { is_expected.to be_valid }
    end

    context "with links" do
      let!(:content) {
        build :content, description: nil
      }
      let!(:build_link) {
        content.content_links.build(attributes_for :content_link)
      }
      before {
        expect(content.content_medium).to be_empty
        expect(content.content_links).to_not be_empty
        expect(content.description).to_not be_present
      }
      it { is_expected.to be_valid }
    end
  end

  describe "neuron should not to be active" do
    it {
      expect(content.neuron.active).to eq(false)
    }
  end

  describe "neuron should change to be active" do
    before {
      content.update! approved: true
    }

    it {
      expect(neuron).to be_active
    }
  end

  describe "neuron should return to be inactive" do
    let(:content) {
      create :content, :approved
    }
    before {
      expect(neuron.reload).to be_active
      content.update! approved: false
    }
    it {
      expect(neuron.reload).to_not be_active
    }
  end

  describe "papertrail should registre event: active_neuron", versioning: true do
    before {
      content.update! approved: true
    }
    it {
      expect(
       neuron.versions.last.event
      ).to eq("active_neuron")
    }
  end

  describe "papertrail should registre event: approve_content", versioning: true do
    #the event if registre only when change approved value
    let(:content) {
      create :content, :approved
    }
    before {
      content.update! approved: false
    }
    it {
      expect(
       content.neuron.versions.last.event
      ).to eq("approve_content")
    }
  end

  describe "spellchecker" do
    let!(:resource) { create :content }
    let(:attributes) { attributes_for :content }
    let(:tracked_attribute) { :description }
    let(:untracked_attribute) { :source }

    include_examples "spellchecker examples"
  end

  describe "#can_have_more_links?" do
    subject { create :content }
    it {
      is_expected.to be_able_to_have_more_links
    }

    context "can't" do
      let!(:links) {
        1.upto(Content::NUMBER_OF_LINKS).each do
          create :content_link,
                 content: subject
        end
      }

      it {
        is_expected.to_not be_able_to_have_more_links
      }
    end
  end
end
