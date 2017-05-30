module PaperTrail
  class VersionDecorator < LittleDecorator
    attr_reader :ignored_keys, :mandatory_keys

    def initialize(*args)
      super(*args)
      ignore_keys "updated_at"
    end

    def user
      @user ||= decorate User.find(whodunnit)
    end

    def sysadmin
      @sysadmin ||= decorate User.new(
        name: "moi",
        email: "moi@macool.me"
      )
    end

    def who
      @who ||= user_exists? ? user : sysadmin
    end

    def changes
      changeset.inject({}) do |memo, (key, value)|
        attribute = localised_attr_for(key)
        value = value.is_a?(Array) ? value.last : value
        memo[attribute] = value_for(key, value)
        memo
      end
    end

    def event_str
      t(
        "views.changelog.done.#{record.event}"
      )
    end

    private

    def user_exists?
      # User.exists?(id: whodunnit)
      whodunnit.present?
    end

    def localised_attr_for(key)
      raise NotImplementedError
    end

    def value_for(key, value)
      if [true, false].include?(value)
        t("views.changelog.#{value}")
      else
        value
      end
    end

    def changeset
      @changeset ||= mandatory_keys_changeset.merge(
        record.changeset.except(*ignored_keys)
      )
    end

    def mandatory_keys_changeset
      mandatory_keys.inject({}) do |memo, key|
        if item.is_a?(Hash)
          memo[key] = item[key]
        else
          memo[key] = item.send(key)
        end
        memo
      end
    end

    def item
      @item ||= record.reify || record.item || YAML.load(record.object_changes)
    end

    def ignore_keys(*keys)
      @ignored_keys ||= []
      @ignored_keys += Array(keys).flatten
    end

    def mandatory_keys(*keys)
      @mandatory_keys ||= []
      @mandatory_keys += Array(keys).flatten
    end
  end
end
