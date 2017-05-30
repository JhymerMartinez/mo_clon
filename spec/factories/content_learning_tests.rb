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

FactoryGirl.define do
  factory :content_learning_test do
    user
    questions {
      times = TreeService::ReadingTestFetcher::MIN_COUNT_FOR_TEST.times
      contents = times.map do
        create :content,
               :with_media,
               :with_correct_possible_answers
      end
      TreeService::LearningTestCreator.new(
        user: user,
        contents: contents
      ).send(:questions)
    }
  end
end
