module Api
  class SearchController < BaseController
    before_action :authenticate_user!
    respond_to :json

    expose(:search_results) {

      neuron_results = NeuronSearch.new(q:params[:query]).results
      content_results = ContentSearch.new(q: params[:query]).results

      results = neuron_results.concat(content_results)

      Kaminari.paginate_array(results)
        .page(params[:page])
        .per(8)
    }

    api :GET,
        "/search",
        "returns search from query"
    param :page, Integer
    param :query, String
    def index
      respond_with(
        search_results,
        meta: {
          total_items: search_results.total_count
        },
        serializer: Api::SearchSerializer
      )
    end
  end
end
