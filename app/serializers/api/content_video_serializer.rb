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

module Api
  class ContentVideoSerializer < ActiveModel::Serializer
    attributes :url,
               :thumbnail
  end
end
