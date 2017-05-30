# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime
#  updated_at             :datetime
#  name                   :string
#  role                   :string           default("cliente"), not null
#  uid                    :string           not null
#  provider               :string           default("email"), not null
#  tokens                 :json
#  birthday               :date
#  city                   :string
#  country                :string
#  tree_image             :string
#

require 'rails_helper'

RSpec.describe User, :type => :model do
  describe "factory" do
    let(:user) { build :user }

    it { expect(user).to be_valid }
  end

  describe "gets notified if role changes" do
    let(:user) { create :user }

    it {
      expect {
        user.update! role: "curador"
      }.to change {
        ActionMailer::Base.deliveries.count
      }.by(1)
    }
  end

  describe "#content_preferences" do
    let(:user) { create :user }
    let(:preferences) { Content::KINDS }

    it "creates them when persisting" do
      expect { user }.to change {
        UserContentPreference.count
      }.by(preferences.count)
    end
  end
end
