module Api
  class ContentPreferencesController < BaseController
    before_action :authenticate_user!

    respond_to :json

    expose(:content_preference) {
      current_user.content_preferences.by_kind(
        params[:id]
      )
    }

    api :PUT,
        "/content_preferences/:kind",
        "update kind preference"
    description "update level for a given kind preference for the current user"
    param :kind, String, required: true
    param :level, Integer, required: true
    def update
      if content_preference.update(level: params[:level])
        render nothing: true,
               status: :accepted
      else
        render nothing: true,
               status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render nothing: true,
             status: :not_found
    end
  end
end
