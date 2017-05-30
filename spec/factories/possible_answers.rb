# == Schema Information
#
# Table name: possible_answers
#
#  id         :integer          not null, primary key
#  content_id :integer          not null
#  text       :string           not null
#  correct    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :possible_answer do
    content
    sequence(:text) { |n| "Possible answer #{n}" }
    correct { [true, false].sample }

    trait :correct do
      correct true
    end
  end
end
