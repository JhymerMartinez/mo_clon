require "rails_helper"

RSpec.describe Api::SessionsController,
               type: :request do
  describe "includes user's content preferences" do
    let!(:user) { create :user }
    let!(:preference) {
      build(:user_content_preference,
            user: user,
            kind: "por-que-es",
            level: 3).tap do |preference|

        # wipe default preference
        user.content_preferences.where(
          kind: preference.kind
        ).destroy_all

        # persist new preference
        preference.save!
      end
    }
    let(:params) {
      { email: user.email,
        password: user.password }
    }

    let(:rendered_preferences) {
      JSON.parse(response.body)["data"]["content_preferences"]
    }
    let(:rendered_preference) {
      rendered_preferences.detect do |pref|
        pref["kind"] == preference[:kind]
      end
    }

    before {
      post "/api/auth/user/sign_in",
           params
    }

    it "renders preference" do
      expect(
        rendered_preference["level"]
      ).to eq(preference.level)
    end

    it {
      expect(
        rendered_preferences.count
      ).to eq(Content::KINDS.count)
    }
  end
end
