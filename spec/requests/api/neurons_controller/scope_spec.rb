require "rails_helper"

RSpec.describe Api::NeuronsController,
               type: :request do
  include CollectionExpectationHelpers

  pending "/api/neurons deprecated in favour of /api/tree"

  describe "unauthenticated #index" do
    let!(:neuron) {
      # we rely on root being present
      create :neuron
    }
    before { get "/api/neurons" }
    subject { response }
    it {
      is_expected.to have_http_status(:unauthorized)
    }
  end

  describe "neuron scope" do
    include_examples "requests:current_user"

    let(:body) {
      JSON.parse(response.body)
    }
    let(:neurons) {
      body.fetch("neurons")
    }
    let(:contents) {
      body.fetch("neurons").map do |neuron|
        neuron.fetch("contents")
      end.flatten
    }

    ##
    # tree
    #       a
    #      / \
    #     b   *c
    #    /\   /\
    #   d *e f *g
    #  /\
    # h *i
    let!(:a) {
      create :neuron,
             :public,
             :with_approved_content
    }
    let!(:b) {
      create :neuron,
             :public,
             :with_approved_content,
             parent: a
    }
    let!(:c) {
      create :neuron, # not public
             :with_content,
             parent: a
    }
    let!(:d) {
      create :neuron,
             :public,
             :with_approved_content,
             parent: b
    }
    let!(:e) {
      create :neuron,
             :with_approved_content,
             parent: b
    }
    let!(:f) {
      create :neuron,
             :public,
             :with_approved_content,
             parent: c
    }
    let!(:g) {
      create :neuron,
             :with_approved_content,
             parent: c
    }
    let!(:h) {
      create :neuron,
             :public,
             :with_approved_content,
             parent: d
    }
    let!(:i) {
      create :neuron,
             :with_approved_content,
             parent: d
    }

    before {
      root_neuron(a)
    }

    context "when I haven't learnt anything" do
      before { get "/api/neurons" }

      it "includes root neuron" do
        expect_to_see_in_collection(a)
      end

      it "doesn't include root children" do
        expect_to_not_see_in_collection(b)
      end

      it "does not include unpublished children & grandchildren" do
        expect_to_not_see_in_collection(c)
        expect_to_not_see_in_collection(g)
      end

      it "does not include root grandchildren" do
        expect_to_not_see_in_collection(d)
      end

      it "does not include unpublished neuron's public children" do
        expect_to_not_see_in_collection(f)
      end
    end

    context "when I have learnt contents" do
      let!(:learning) {
        create :content_learning,
               user: current_user,
               content: b.contents.first
      }

      before { get "/api/neurons" }

      it "includes learnt contents' published neurons" do
        expect_to_see_in_collection(a)
        expect_to_see_in_collection(b)
      end

      it "doesn't include learnt unpublished neurons" do
        expect_to_not_see_in_collection(e)
      end

      it "includes learnt contents' neurons published children" do
        expect_to_see_in_collection(d)
      end

      it "doesn't include unlearnt neurons" do
        expect_to_not_see_in_collection(h)
      end

      describe "contents scope" do
        let!(:approved_content) {
          create :content,
                 :approved,
                 neuron: b
        }
        let!(:unapproved_content) {
          create :content,
                 neuron: b
        }

        before { get "/api/neurons" }

        it "includes approved content" do
          expect_to_see_in_collection(approved_content)
        end

        it "doesn't include unapproved content" do
          expect_to_not_see_in_collection(unapproved_content)
        end
      end
    end

    context "when I have learnt deeper contents" do
      let!(:learnings) {
        [
          create(
            :content_learning,
            user: current_user,
            content: b.contents.first
          ),
          create(
            :content_learning,
            user: current_user,
            content: d.contents.first
          )
        ]
      }

      before { get "/api/neurons" }

      it "includes learnt content's published neurons" do
        expect_to_see_in_collection(a)
        expect_to_see_in_collection(b)
        expect_to_see_in_collection(d)
      end

      it "doesn't include unpublished neurons" do
        expect_to_not_see_in_collection(c)
        expect_to_not_see_in_collection(e)
        expect_to_not_see_in_collection(i)
      end

      it "includes published children" do
        expect_to_see_in_collection(h)
      end
    end
  end
end
