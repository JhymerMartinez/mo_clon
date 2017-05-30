# == Schema Information
#
# Table name: content_videos
#
#  id         :integer          not null, primary key
#  content_id :integer          not null
#  url        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ContentVideo,
               type: :model do
  describe "factory" do
    subject { build :content_video }
    it { is_expected.to be_valid }
    it { expect(subject.content).to be_a(Content) }
  end
end
