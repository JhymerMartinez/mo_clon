module Api
  class SearchUsersSerializer < ActiveModel::Serializer
    attributes  :users

    def users
      result = select_only(User)
      serialize_with(UserSerializer, result)
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
