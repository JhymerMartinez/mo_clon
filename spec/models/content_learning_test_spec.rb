# == Schema Information
#
# Table name: content_learning_tests
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  questions  :json             not null
#  answers    :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  completed  :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe ContentLearningTest,
               type: :model do
  describe "factory" do
    subject {
      build :content_learning_test
    }
    it { is_expected.to be_valid }
  end
end
