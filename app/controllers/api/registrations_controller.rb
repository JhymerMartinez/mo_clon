module Api
  class RegistrationsController < DeviseTokenAuth::RegistrationsController
    extend BaseDoc
    include BaseController::JsonRequestsForgeryBypass
    before_filter :configure_permitted_parameters

    resource_description do
      short "user registration"
      description "registrations handled by [`devise_token_auth` gem](https://github.com/lynndylanhurley/devise_token_auth)"
    end

    doc_for :create do
      api :POST,
          "/auth/user",
          "sign up providing email"
      description "create new account for moi. Responds with created user if successful"
      param :name, String, required: true
      param :birthday, Date, required: false
      param :password, String, required: true
      param :city, String, required: false
      param :confirm_password, String, required: true
      param :country, String, required: false
      param :email, String, required: true
    end

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up).push(:name,:birthday,:country,:city)
    end
  end
end
