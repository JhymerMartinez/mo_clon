require "rails_helper"

RSpec.describe Api::TreesController,
               type: :request do
  include RootNeuronMockable

  include_examples "requests:current_user"

  let!(:root) { create :neuron_visible_for_api }

  let(:response_depth) {
    JSON.parse(response.body)
        .fetch("meta")
        .fetch("depth")
  }

  subject { response_depth }

  before { root_neuron root }

  describe "1 level depth" do
    before { get "/api/tree" }
    it { is_expected.to eq(1) }
  end

  describe "3 levels depth" do
    # root
    #  /\
    # a  b
    #   /
    #  c
    let!(:a) {
      create :neuron_visible_for_api,
             title: "a",
             parent: root
    }
    let!(:b) {
      create :neuron_visible_for_api,
             title: "b",
             parent: root
    }
    let!(:c) {
      create :neuron_visible_for_api,
             title: "c",
             parent: b
    }

    let!(:learning) {
      create :content_learning,
             user: current_user,
             content: b.contents.first
    }

    before { get "/api/tree" }
    it { is_expected.to eq(3) }
  end

  describe "5 levels depth" do
    # root
    #  /\
    # a  b
    #   / \
    #  c  d
    #    /
    #   e
    #  /
    # f
    let!(:a) {
      create :neuron_visible_for_api,
             title: "a",
             parent: root
    }
    let!(:b) {
      create :neuron_visible_for_api,
             title: "b",
             parent: root
    }
    let!(:c) {
      create :neuron_visible_for_api,
             title: "c",
             parent: b
    }
    let!(:d) {
      create :neuron_visible_for_api,
             title: "d",
             parent: b
    }
    let!(:e) {
      create :neuron_visible_for_api,
             title: "e",
             parent: d
    }
    let!(:f) {
      create :neuron_visible_for_api,
             title: "f",
             parent: e
    }

    let!(:learnings) {
      [
        b.contents.first,
        d.contents.first,
        e.contents.first
      ].map do |content|
        create :content_learning,
               user: current_user,
               content: content
      end
    }

    before { get "/api/tree" }
    it { is_expected.to eq(5) }
  end
end
