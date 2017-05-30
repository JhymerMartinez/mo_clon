# == Schema Information
#
# Table name: content_videos
#
#  id         :integer          not null, primary key
#  content_id :integer          not null
#  url        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ContentVideo < ActiveRecord::Base
  include Embeddable
  belongs_to :content
  has_paper_trail ignore: [:created_at, :updated_at, :id]
end
