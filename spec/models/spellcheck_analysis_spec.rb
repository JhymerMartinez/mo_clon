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

require 'rails_helper'

RSpec.describe SpellcheckAnalysis, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
