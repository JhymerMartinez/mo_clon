module PaperTrail
  class NeuronVersionDecorator < VersionDecorator
    include Relationships

    def changed_attrs
      changed_keys.map { |key|
        t("activerecord.attributes.neuron.#{key}").downcase
      }.join ", "
    end

    def time_ago
      t(
        "views.changelog.time_ago",
        time_ago: time_ago_in_words(created_at)
      )
    end

    def event_explanation
      t(
        "views.changelog.#{record.event}"
      ) + (changed_keys.any? ? ":" : "")
    end

    def changed_keys
      @changed_keys ||= changeset.keys + extra_keys
    end

    private

    def localised_attr_for(key)
      t("activerecord.attributes.neuron.#{key}")
    end

    def value_for(key, value)
      case key
      when "parent_id"
        if value.present?
          Neuron.find(value).title
        else
          "-"
        end
      else
        super
      end
    end

    def extra_keys
      RELATIONSHIPS.select do |relationship|
        send "#{relationship}_changed?"
      end
    end
  end
end
