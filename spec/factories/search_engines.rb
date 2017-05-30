# == Schema Information
#
# Table name: search_engines
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  slug       :string           not null
#  active     :boolean          default(TRUE)
#  gcse_id    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :search_engine do
    sequence(:name) { |n| "Search Engine #{n}" }
    sequence(:slug) {|n| "searchengine#{n}" }
    active true
    sequence(:gcse_id) {|n| "pqncoir:asd:#{n}" }
  end
end
