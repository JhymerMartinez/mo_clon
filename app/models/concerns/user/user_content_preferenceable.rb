class User < ActiveRecord::Base
  module UserContentPreferenceable
    extend ActiveSupport::Concern

    included do
      after_create :create_content_preferences!
    end

    private

    ##
    # create necessary content preferences
    # without overriding existing ones
    def create_content_preferences!
      Content::KINDS.each do |kind|
        content_preferences.where(
          kind: kind,
          order: assign_order_by_kind(kind)
        ).first_or_create
      end
    end

    ##
    # update order field existing ones
    def assign_order_content_preferences!
      content_preferences.each do |preference|
        preference.update(order: assign_order_by_kind(preference.kind))
      end
    end

    def assign_order_by_kind(kind)
      UserContentPreference::DEFAULT_ORDER[kind.to_sym]
    end

  end
end
