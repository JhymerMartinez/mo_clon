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

FactoryGirl.define do
  factory :profile do
    user

    sequence(:name) { |n| "Profile #{n}" }
    biography "Biography"
  end
end
