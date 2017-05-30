module Api
  class TokenValidationsController < DeviseTokenAuth::TokenValidationsController
    extend BaseDoc
    include DeviseTokenAuth::Concerns::SetUserByToken
    include BaseController::JsonRequestsForgeryBypass

    resource_description {
      short "user session token validation"
      description "validations handled by `devise_token_auth` gem"
    }

    doc_for :validate_token do
      api :GET,
          "/auth/user/validate_token",
          "validate user's token"
      description "Each client will get a unique token. Tokens for each user will be randomly generated. These tokens are unique for user and client and they may expire. It's the client's responsibility to always keep the token up-to-date"
      example '{"success":true,"data":{"id":1,"email":"somebody@example.com","name":"Somebody","role":"role","uid":"somebody@example.com","provider":"email"}}'
      meta "required headers" => {
        :"access-token" => "unique token for user. may expire and must be recorder within each request",
        :"client" => "identifier for the app using the token",
        :"expiry" => "timestamp (when the token expires)",
        :"token-type" => "Bearer",
        :"uid" => "user id (email)"
      }
    end

    private

    def render_validate_token_success
      render json: {
        success: true,
        data: UserSerializer.new(@resource)
      }
    end
  end
end
