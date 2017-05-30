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

class SearchEngine < ActiveRecord::Base
  scope :active, ->{ where(active: true) }

  begin :validations
    validates :name, presence: true
    validates :slug, presence: true,
                     uniqueness: true
    validates :gcse_id, presence: true,
                        uniqueness: true
  end

  def to_s
    name
  end
end
