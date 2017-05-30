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

module Api
  class ContentNoteSerializer < ActiveModel::Serializer
    attributes :id,
               :content_id,
               :neuron_id,
               :note

    def content_id
      object.content.id
    end
    def neuron_id
      object.content.neuron_id
    end
  end
end
