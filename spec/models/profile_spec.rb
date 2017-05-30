# == Schema Information
#
# Table name: profiles
#
#  id         :integer          not null, primary key
#  name       :string
#  biography  :text
#  user_id    :integer          not null
#  neuron_ids :text             default([]), is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe "factory" do
    let(:profile) { build :profile }
    it { expect(profile).to be_valid }
  end
end
