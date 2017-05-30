# == Schema Information
#
# Table name: neurons
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  parent_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  active     :boolean          default(FALSE)
#  deleted    :boolean          default(FALSE)
#  is_public  :boolean          default(FALSE)
#  position   :integer          default(0)
#

class NeuronSerializer < ActiveModel::Serializer
  attributes :id,
             :parent_id,
             :title,
             :is_public,
             :active,
             :deleted
end
