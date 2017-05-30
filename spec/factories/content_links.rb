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

FactoryGirl.define do
  factory :content_link do
    content
    link "http://mysharedlink.domain.org"
  end
end
