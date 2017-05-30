module Api
  class SearchSerializer < ActiveModel::Serializer
    attributes  :contents,
                :neurons

    def contents
      result = select_only(Content)
      serialize_with(ContentSerializer, result)
    end

    def neurons
      result = select_only(Neuron)
      serialize_with(NeuronSerializer, result)
    end

    def serialize_with(serializer_type, result)
      if result.any?
        ActiveModel::ArraySerializer.new(
          result,
          each_serializer: serializer_type,
          scope: @scope
        )
      else
        result
      end
    end

    def select_only(type)
      result = object.select do |hash|
        hash.is_a?(type)
      end
    end
  end
end
