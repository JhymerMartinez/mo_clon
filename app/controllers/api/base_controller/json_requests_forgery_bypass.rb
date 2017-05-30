module Api
  class BaseController < ::ApplicationController
    module JsonRequestsForgeryBypass
      extend ActiveSupport::Concern

      included do
        skip_before_action :verify_authenticity_token,
                           if: :json_request?
      end

      protected

      def json_request?
        request.headers["Content-Type"].include?("application/json") if request.headers["Content-Type"].present?
      end
    end
  end
end
