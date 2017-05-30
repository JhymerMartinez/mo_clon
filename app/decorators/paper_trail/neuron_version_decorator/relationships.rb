module PaperTrail
  class NeuronVersionDecorator < VersionDecorator
    module Relationships
      RELATIONSHIP_MAPPING = {
        "contents" => "Content",
        "links" => "ContentLink",
        "medium" => "ContentMedia",
        "videos" => "ContentVideo"
      }
      RELATIONSHIPS = RELATIONSHIP_MAPPING.keys

      def render_relationship_changes
        RELATIONSHIPS.select do |relationship|
          send "#{relationship}_changed?"
        end.map do |relationship|
          render(
            "relationship_changes",
            kind: relationship,
            collection: send("changed_#{relationship}")
          )
        end.join.html_safe
      end

      RELATIONSHIPS.each do |relationship|
        define_method "#{relationship}_changed?" do
          # may have to enhance:
          # Version.exists?(
          #   item_type: "Content",
          #   transaction_id: transaction_id
          # )
          send("raw_#{relationship}").length > 0
        end

        define_method "raw_#{relationship}" do
          cached = instance_variable_get(:"@raw_#{relationship}")
          return cached if cached.present?
          scope = Version.where(
            transaction_id: transaction_id,
            item_type: RELATIONSHIP_MAPPING[relationship]
          )
          instance_variable_set(:"@raw_#{relationship}", scope)
        end

        define_method "changed_#{relationship}" do
          cached = instance_variable_get(:"@changed_#{relationship}")
          return cached if cached.present?
          klass = RELATIONSHIP_MAPPING[relationship]
          decorated_collection = decorate(
            send("raw_#{relationship}"),
            "PaperTrail::#{klass}VersionDecorator".constantize
          )
          instance_variable_set(
            :"@changed_#{relationship}",
            decorated_collection
          )
        end
      end
    end
  end
end
