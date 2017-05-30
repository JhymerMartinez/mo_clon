# == Schema Information
#
# Table name: user_seen_images
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  media_url  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserSeenImage < ActiveRecord::Base
  belongs_to :user
end
