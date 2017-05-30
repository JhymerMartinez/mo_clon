# == Schema Information
#
# Table name: content_readings
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  content_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  neuron_id  :integer          not null
#

require 'rails_helper'

RSpec.describe ContentReading,
               type: :model do
  describe "factory" do
    subject { build :content_reading }
    it { is_expected.to be_valid }
    it {
      expect(subject.user).to be_present
    }
    it {
      expect(subject.content).to be_present
    }
  end
end
