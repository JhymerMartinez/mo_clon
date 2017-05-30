# == Schema Information
#
# Table name: user_content_preferences
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  kind       :string           not null
#  level      :integer          default(1), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  order      :integer
#

class UserContentPreference < ActiveRecord::Base
  extend IntegersEnumerable

  DEFAULT_ORDER = integers_enumerable(Content::KINDS)
  ORDER = DEFAULT_ORDER.values

  belongs_to :user
  validates :user,
            :kind,
            :level,
            :order,
            presence: true
  validates :kind,
            inclusion: { in: Content::KINDS }
  validates :level,
            inclusion: { in: Content::LEVELS }
  validates :order,
            inclusion: { in: ORDER }

  ##
  # @param [String] kind
  # @raise [ActiveRecord::NotFound] if provided
  #   kind doesn't exist
  scope :by_kind, ->(kind) do
    find_by!(kind: kind)
  end

  def kind
    read_attribute(:kind).try :to_sym
  end

end
