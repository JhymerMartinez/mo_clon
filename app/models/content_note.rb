# == Schema Information
#
# Table name: content_notes
#
#  id         :integer          not null, primary key
#  content_id :integer          not null
#  user_id    :integer          not null
#  note       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ContentNote < ActiveRecord::Base
  belongs_to :content
  belongs_to :user

  validates :user_id,
            presence: true
  validates :content_id,
            presence: true
  validates :note,
            presence: true
end
