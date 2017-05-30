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

FactoryGirl.define do
  factory :user_content_preference do
    user
    kind { Content::KINDS.sample }
    level { Content::LEVELS.sample }
    order { UserContentPreference::ORDER.sample }
  end
end
