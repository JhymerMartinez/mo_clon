  # == Schema Information
#
# Table name: possible_answers
#
#  id         :integer          not null, primary key
#  content_id :integer          not null
#  text       :string           not null
#  correct    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PossibleAnswer < ActiveRecord::Base
  include SpellcheckAnalysable

  SPELLCHECK_ATTRIBUTES = %w( text ).freeze

  begin :relationships
    belongs_to :content
  end

  begin :validations
    validates :text, presence: true
  end
end
