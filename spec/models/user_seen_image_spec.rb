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

require 'rails_helper'

RSpec.describe UserSeenImage, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
