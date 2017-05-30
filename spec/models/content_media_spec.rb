# == Schema Information
#
# Table name: content_media
#
#  id         :integer          not null, primary key
#  media      :string
#  content_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ContentMedia,
               type: :model do
  describe "factory" do
    subject { build :content_media }
    it { is_expected.to be_valid }
    it {
      expect(subject.content).to be_a(Content)
    }
  end
end
