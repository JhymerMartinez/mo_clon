module Api
  class StatisticsSerializer < ActiveModel::Serializer
    attributes  :total_notes,
                :user_sign_in_count,
                :user_created_at,
                :user_updated_at,
                :images_opened_in_count,
                :total_neurons_learnt,
                :user_tests,
                :total_content_readings

    def total_notes
      object["total_notes"]
    end

    def user_sign_in_count
      object["user_sign_in_count"]
    end

    def user_created_at
      object["user_created_at"]
    end

    def user_updated_at
      object["user_updated_at"]
    end

    def images_opened_in_count
      object["images_opened_in_count"]
    end

    def total_neurons_learnt
      object["total_neurons_learnt"]
    end

    def user_tests
      object["user_tests"]
    end

    def total_content_readings
      object["total_content_readings"]
    end
  end
end
