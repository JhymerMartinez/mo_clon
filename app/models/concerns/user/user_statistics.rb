class User < ActiveRecord::Base
  module UserStatistics

    def generate_statistics
      statistics = {}
      statistics["total_notes"] = ContentNote.where(user: self).size
      statistics["user_sign_in_count"] = self.sign_in_count
      statistics["user_created_at"] = self.created_at
      statistics["user_updated_at"] = self.updated_at
      statistics["images_opened_in_count"] = UserSeenImage.where(user: self).size
      statistics["total_neurons_learnt"] = TreeService::LearntNeuronsFetcher.new(self).ids.uniq.size
      statistics["user_tests"] = AnalyticService::TestStatistic.new(self).results
      statistics["user_tests"] = AnalyticService::TestStatistic.new(self).results
      statistics["total_content_readings"] = self.content_readings.size
      statistics
    end
  end
end
