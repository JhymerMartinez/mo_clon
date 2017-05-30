# == Schema Information
#
# Table name: profiles
#
#  id         :integer          not null, primary key
#  name       :string
#  biography  :text
#  user_id    :integer          not null
#  neuron_ids :text             default([]), is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Profile < ActiveRecord::Base
  belongs_to :user

  ##
  # rejects blanks and casts to Array
  #
  # @example Using strings
  #   profile.neuron_ids = "1,2,3"
  # @example Using array
  #   profile.neuron_ids = [1,2,3,""]
  def neuron_ids=(ids)
    ids = ids.split(",") if ids.is_a?(String)
    write_attribute :neuron_ids,
                    Array(ids).flatten
                              .reject(&:blank?)
  end
end
