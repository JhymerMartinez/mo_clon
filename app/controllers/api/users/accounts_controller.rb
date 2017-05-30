module Api
  module Users
    class AccountsController < BaseController
      before_action :authenticate_user!

      expose(:user) {
        current_user
      }

      # expose(:user, attributes: :user_params)

      api :PUT,
          "/users/account",
          "Update user account"
      param :name, String
      param :birthday, Date
      param :password, String, "if you want to update your account's password"
      param :city, String
      param :country, String
      param :email, String
      def update
        if current_user.valid_password?(user_params[:current_password])
          if user.update(user_params_update)
            render  nothing:true,
                    status: :accepted
          else
            @errors = current_user.errors
            render  nothing: true,
                    status: unprocessable_entity
          end
        else
          @errors = current_user.errors
          render  nothing: true,
                  status: 401
        end
      end

      private

      def user_params
        params.require(:account).permit(:name,
                                    :birthday,
                                    :password,
                                    :city,
                                    :country,
                                    :email,
                                    :current_password
                                  )
      end
      def user_params_update
        user_params.except(:current_password)
      end
    end
  end
end
