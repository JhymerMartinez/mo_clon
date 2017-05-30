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

FactoryGirl.define do
  factory :content_video do
    content
    url "http://youtube.com/embedded_video"
  end
end
