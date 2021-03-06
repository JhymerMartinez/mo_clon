# == Schema Information
#
# Table name: content_readings
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  content_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  neuron_id  :integer          not null
#

FactoryGirl.define do
  factory :content_reading do
    user
    content
  end
end
