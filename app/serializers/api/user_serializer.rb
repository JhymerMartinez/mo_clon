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
  class UserSerializer < ActiveModel::Serializer
    root false

    attributes :id,
               :email,
               :name,
               :role,
               :uid,
               :provider,
               :country,
               :birthday,
               :city,
               :tree_image

    has_many :content_preferences

    def content_preferences
      object.content_preferences.map do |preference|
        {
          kind: preference.kind,
          level: preference.level,
          order: preference.order
        }
      end
    end

    def tree_image
      object.tree_image.url
    end
  end
end
