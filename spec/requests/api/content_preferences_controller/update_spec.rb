require "rails_helper"

RSpec.describe Api::ContentPreferencesController,
               type: :request do
  let(:current_user) { create :user }
  before { login_as current_user }

  let(:preference) {
    build :user_content_preference,
          user: current_user
  }

  let(:user_preference) {
    current_user.content_preferences.by_kind(
      preference.kind
    )
  }

  let(:endpoint) {
    "/api/content_preferences/#{preference.kind}"
  }

  describe "update content preferences" do
    before {
      expect {
        put endpoint, level: preference.level, order: preference.order
      }.to_not change(UserContentPreference, :count)
    }

    it {
      expect(response.status).to eq(202)
    }

    it "persists preference" do
      expect(
        user_preference.level
      ).to eq(preference.level)
    end

    it "doesn't create new preferences" do
      expect(
        current_user.content_preferences.count
      ).to eq(Content::KINDS.count)
    end
  end

  describe "non-existing preference" do
    before {
      put "/api/content_preferences/nonexistent", level: 1
    }

    it {
      expect(response.status).to eq(404)
    }
  end

  describe "level out of bounds" do
    before {
      expect {
        put endpoint, level: 5
      }.to_not change(user_preference, :level)
    }

    it {
      expect(response.status).to eq(422)
    }
  end

  describe "order out of bounds" do
    before {
      expect {
        put endpoint, order: 99
      }.to_not change(user_preference, :order)
    }

    it {
      expect(response.status).to eq(422)
    }
  end
end
