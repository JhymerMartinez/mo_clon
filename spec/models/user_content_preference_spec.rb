# == Schema Information
#
# Table name: user_content_preferences
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  kind       :string           not null
#  level      :integer          default(1), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  order      :integer
#

require 'rails_helper'

RSpec.describe UserContentPreference,
               type: :model do
  describe "factory" do
    subject { build :user_content_preference }
    it { is_expected.to be_valid }
  end
end
