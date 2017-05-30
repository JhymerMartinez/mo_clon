# == Schema Information
#
# Table name: content_media
#
#  id         :integer          not null, primary key
#  media      :string
#  content_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :content_media,
          class: "ContentMedia" do
    content
    media "uploaded_media"
  end
end
