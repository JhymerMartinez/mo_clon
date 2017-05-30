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

class SpellcheckAnalysis < ActiveRecord::Base
  begin :validations
    validates :attr_name, presence: true
  end

  begin :relationships
    belongs_to :analysable, polymorphic: true
  end

  begin :scopes
    scope :for, -> (attr_name) {
      where(attr_name: attr_name)
    }
  end
end
