# == Schema Information
#
# Table name: content_links
#
#  id         :integer          not null, primary key
#  content_id :integer          not null
#  link       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ContentLink,
               type: :model do
  describe "factory" do
    subject { build :content_link }
    it { is_expected.to be_valid }
  end
end
