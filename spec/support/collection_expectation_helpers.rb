module CollectionExpectationHelpers
  def expect_to_see_in_collection(resource, collection = nil)
    expect(
      resource_in_collection(resource, collection)
    ).to be_present
  end

  def expect_to_not_see_in_collection(resource, collection = nil)
    expect(
      resource_in_collection(resource, collection)
    ).to_not be_present
  end

  def collection_for(resource, collection)
    if collection.nil?
      send(resource.class.to_s.pluralize.downcase)
    else
      Array(collection)
    end
  end

  def resource_in_collection(resource, collection)
    collection_for(resource, collection).detect do |n|
      n["id"] == resource.id
    end
  end
end
