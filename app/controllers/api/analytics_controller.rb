module Api
  class AnalyticsController < BaseController
    before_action :authenticate_user!

    expose(:statistics_data) {
      current_user.generate_statistics
    }

    respond_to :json

    api :GET,
        "/analytics/statistics",
        "shows user statistics data"
    description "Responds with the user statistics data, this endpoint belongs to the Analytics Module"
    example %q{
        {
          "statistics": {
          "total_notes": 5,
          "user_sign_in_count": 17,
          "user_created_at": "2017-03-16T21:33:37.982-05:00",
          "user_updated_at": "2017-04-12T23:51:37.677-05:00",
          "images_opened_in_count": 4,
          "total_neurons_learnt": 3,
          "user_tests": [
            {
              "test_id": 1,
              "questions": [
                {
                  "content_id": 1,
                  "content_title": "content title 1",
                  "correct": true
                },
                {
                  "content_id": 2,
                  "content_title": "content title 2",
                  "correct": false
                },
                {
                  "content_id": 3,
                  "content_title": "content title 3",
                  "correct": true
                },
                {
                  "content_id": 4,
                  "content_title": "content title 4",
                  "correct": true
                }
              ]
            }
          ]
        }
      }
    }

    def statistics
      respond_with(
        statistics_data,
        serializer: Api::StatisticsSerializer
      )
    end

  end
end
