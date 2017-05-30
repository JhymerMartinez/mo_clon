module Api
  ##
  # idea taken from
  # http://ilyabylich.svbtle.com/apipie-amazing-tool-for-documenting-your-rails-api
  module BaseDoc
    def defaults(&block)
      @defaults = block
    end

    ##
    # defines a method only used for the
    # api's documentation. Use it when
    # you're documented an inherited
    # method or some endpoint that's
    # not being showed by apipie
    def doc_for(action_name, &block)
      instance_eval(&block)
      instance_eval(&@defaults) if @defaults
      # api_version namespace_name if namespace_name
      define_method("api_#{action_name}") do
        # ... define it in your controller with the real code
      end
    end
  end
end
