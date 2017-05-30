# == Schema Information
#
# Table name: content_notes
#
#  id         :integer          not null, primary key
#  content_id :integer          not null
#  user_id    :integer          not null
#  note       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :content_note do
    user
    content
    sequence(:note) { |n| "noted stuff #{n}" }
  end
end
