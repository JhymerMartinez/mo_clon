module Api
  module Users
    class TreeImagesController < BaseController
      before_action :authenticate_user!

      expose(:user) {
        current_user
      }

      api :PUT,
          "/users/tree_image",
          "create user tree"
      param :image, String

      def update
        if user.update(tree_image: params[:image])
          response = {
            status: :accepted,
            user: user
          }
        else
          @errors = current_user.errors
          response = {
            nothing: true,
            status: :unprocessable_entity
          }
        end
        render json: response,
               status: response[:status]
      end
    end
  end
end
