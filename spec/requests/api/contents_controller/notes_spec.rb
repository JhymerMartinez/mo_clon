require "rails_helper"

RSpec.describe Api::ContentsController,
               type: :request do
  include_examples "neurons_controller:approved_content"

  let(:current_user) { create :user }
  let(:content_note) { current_user.content_notes.first }

  let(:endpoint) {
    "/api/neurons/#{neuron.id}/contents/#{content.id}/notes"
  }

  describe "#notes" do
    let(:note) { "These are some notes" }
    before { login_as current_user }

    before {
      expect {
        post endpoint, note: note
      }.to change {
        current_user.content_notes.count
      }.by(1)
    }

    it {
      expect(response).to be_success
      expect(content_note.content).to eq(content)
      expect(content_note.note).to eq(note)
    }
  end

  describe "unauthenticated #notes" do
    before { post endpoint }

    it {
      expect(response).to have_http_status(:unauthorized)
    }
  end

  context "existing content notes" do
    let!(:existing_note) {
      create :content_note,
             content: content,
             user: current_user
    }

    before { login_as current_user }

    describe "updates content notes" do
      let(:note) { "This is the new note" }

      before {
        expect {
          post endpoint, note: note
        }.to_not change {
          current_user.content_notes.count
        }
      }

      it {
        expect(response).to be_success
        expect(content_note.id).to eq(existing_note.id)
        expect(content_note.content).to eq(content)
        expect(content_note.note).to eq(note)
      }
    end

    describe "deletes content notes" do
      before {
        expect {
          post endpoint
        }.to change {
          current_user.content_notes.count
        }.by(-1)
      }

      it {
        expect(
          current_user.content_notes
        ).to_not include(existing_note)
      }
    end
  end
end
