# == Schema Information
#
# Table name: spellcheck_analyses
#
#  id              :integer          not null, primary key
#  attr_name       :string           not null
#  words           :json             default([])
#  analysable_id   :integer          not null
#  analysable_type :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  success         :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :spellcheck_analysis do
    attr_name "MyString"
    words []
    analysable_id 1
    analysable_type "MyString"
  end
end
