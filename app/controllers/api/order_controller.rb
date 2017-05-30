module Api
  class OrderController < BaseController
    before_action :authenticate_user!

    respond_to :json

    expose(:content_preference) {
      current_user.content_preferences
    }

    api :PUT,
        "/order",
        "update order coontent preference"
    description "update order preference"
    param :inorder, String, required: true, desc: %{
    needs to be a JSON-encoded string having the following format:


    [
      { "kind": "que-es", "order": "2" },
      { "kind": "como-funciona", "order": "3" },
      { "kind": "por-que-es", "order": "1" },
      { "kind": "quien-cuando-donde", "order": "0" }
    ]
    }
    def update
      inorder = JSON.parse(params[:inorder])
      if !inorder.empty?
        inorder.map do |option|
          preference = find_preference(option['kind'])
          preference.update(order: option['order'])
        end
        render nothing: true,
               status: :accepted
      else
        render nothing: true,
               status: :unprocessable_entity
      end
    end

    private

    def find_preference(kind)
      content_preference.find_by_kind(kind)
    end
  end
end
