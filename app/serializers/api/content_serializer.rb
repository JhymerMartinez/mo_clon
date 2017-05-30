# == Schema Information
#
# Table name: contents
#
#  id          :integer          not null, primary key
#  level       :integer          not null
#  kind        :string           not null
#  description :text             not null
#  neuron_id   :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  source      :string
#  approved    :boolean          default(FALSE)
#  title       :string
#

module Api
  class ContentSerializer < ActiveModel::Serializer
    attributes :id,
               :neuron_id,
               :media,
               :level,
               :kind,
               :description,
               :source,
               :title,
               :read,
               :learnt,
               :links,
               :videos,
               :user_notes,
               :content_tasks,
               :neuron_can_read

    def read
      current_user.already_read?(object)
    end

    def learnt
      current_user.already_learnt?(object)
    end

    def user_notes
      object.user_note(current_user).try :note
    end

    def media
      object.content_medium.map(&:media_url)
    end

    def links
      object.content_links.map(&:link)
    end

    def neuron_can_read
      visible_neurons = TreeService::PublicScopeFetcher.new(@scope).neurons
      visible_neurons.map(&:id).include?(object.neuron.id)
    end

    def videos
      ActiveModel::ArraySerializer.new(
        object.content_videos,
        each_serializer: ContentVideoSerializer
      )
    end

    alias_method :current_user, :scope
  end
end
