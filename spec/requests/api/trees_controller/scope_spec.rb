require "rails_helper"

RSpec.describe Api::TreesController,
               type: :request do
  include RootNeuronMockable
  include CollectionExpectationHelpers

  pending "scope is best described in neurons_controller/scope_spec"

  include_examples "requests:current_user"

  let(:endpoint) {
    "/api/tree"
  }

  let!(:root) {
    create :neuron_visible_for_api
  }

  describe "root has right attributes" do
    subject {
      JSON.parse(response.body)
          .fetch("tree")
          .fetch("root")
    }

    before { get endpoint }

    %w(
      id
      title
      children
    ).each do |field|
      it "includes #{field}" do
        is_expected.to have_key(field)
      end
    end
  end

  describe "root children" do
    let!(:a) {
      create :neuron_visible_for_api,
             parent: root
    }
    let!(:b) {
      create :neuron,
             parent: root
    }

    let(:neurons) {
      JSON.parse(response.body)
          .fetch("tree")
          .fetch("root")
          .fetch("children")
    }

    before {
      root_neuron root
      get endpoint
    }

    it "doesn't include neurons if I haven't learnt anything" do
      expect_to_not_see_in_collection(a)
      expect_to_not_see_in_collection(b)
    end

    describe "when I read something" do
      before {
        create :content_learning,
               user: current_user,
               content: root.contents.first
      }

      before { get endpoint }

      it "includes visible neuron" do
        expect_to_see_in_collection(a)
      end

      it "doesn't include non-public neuron" do
        expect_to_not_see_in_collection(b)
      end
    end

    describe "root grandchildren" do
      let!(:b) {
        create :neuron_visible_for_api,
               parent: root
      }
      let!(:c) {
        create :neuron_visible_for_api,
               parent: a
      }
      let!(:d) {
        create :neuron_visible_for_api,
               parent: b
      }

      let!(:learning) {
        create :content_learning,
               user: current_user,
               content: a.contents.first
      }

      before {
        root_neuron root
        get endpoint
      }

      let(:neurons) {
        JSON.parse(response.body)
            .fetch("tree")
            .fetch("root")
            .fetch("children")
            .map do |neuron|
              neuron.fetch("children")
            end
            .flatten
            .compact
      }

      it "includes children I've learnt contents for" do
        expect_to_see_in_collection(c)
      end

      it "doesn't include contents when I've not learnt" do
        expect_to_not_see_in_collection(d)
      end
    end
  end
end
