# == Schema Information
#
# Table name: content_learnings
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  content_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  neuron_id  :integer          not null
#

class ContentLearning < ActiveRecord::Base
  belongs_to :user
  belongs_to :content

  validates :user_id,
            presence: true
  validates :content_id,
            presence: true

  before_save :cache_neuron_id

  private

  def cache_neuron_id
    self.neuron_id = content.neuron.id
  end
end
