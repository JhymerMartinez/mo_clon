# == Schema Information
#
# Table name: content_media
#
#  id         :integer          not null, primary key
#  media      :string
#  content_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ContentMedia < ActiveRecord::Base
  belongs_to :content,
             counter_cache: :media_count

  has_paper_trail ignore: [:created_at, :updated_at, :id]

  mount_uploader :media, ContentMediaUploader
end
