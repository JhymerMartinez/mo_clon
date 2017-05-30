# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime
#  updated_at             :datetime
#  name                   :string
#  role                   :string           default("cliente"), not null
#  uid                    :string           not null
#  provider               :string           default("email"), not null
#  tokens                 :json
#  birthday               :date
#  city                   :string
#  country                :string
#

module Api
  class UserProfileSerializer < ActiveModel::Serializer
    root false

    attributes :id,
               :email,
               :name,
               :country,
               :birthday,
               :age,
               :city,
               :last_contents_learnt,
               :tree_image

    def age
      birthday = object.birthday
      if birthday
        now = Time.now.utc.to_date
        now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
      end
    end

    def last_contents_learnt
      object.content_learnings.last(4).map do |content_learnt|
        content = content_learnt.content
        {
          id: content.id,
          media: content.content_medium.map(&:media_url),
          title: content.title,
          neuron_id: content.neuron_id
        }
      end
    end

    def tree_image
      object.tree_image.url
    end
  end
end
