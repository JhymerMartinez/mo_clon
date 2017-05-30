require "rails_helper"

RSpec.describe User::Roles do
  let(:admin) { create :user, :admin }
  let(:moderador) { create :user, :moderador }
  let(:curador) { create :user, :curador }
  let(:cliente) { create :user, :cliente }
  let(:tutor) { create :user, :tutor }

  User.roles.each do |role|
    describe "role #{role}" do
      let(:user) { send(role) }
      let(:other_role) {
        User.roles.reject{|r| r == role }.sample
      }

      it {
        expect(user).to send("be_#{role}")
        expect(user).to_not send("be_#{other_role}")
        # eg
        # expect(user).to be_admin
        # expect(user).to_not be_moderador
      }
    end
  end
end
