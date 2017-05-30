module Tutor
  class AnalysisController < TutorController::Base
    require 'time_diff'

    expose(:client_data) {
      User.where(id: params[:id], role: :cliente)
    }

    def index
      if params[:search]
        @clients =  UserClientSearch.new(q:params[:search]).results
      else
        @clients = User.where(:role => :cliente)
      end
    end

    def show
      @client = client_data.first
      @statistics = @client.generate_statistics
      @statistics["total_right_questions"] = total_right_questions(@statistics["user_tests"])
      @statistics["used_time"] = time_diff(@statistics)
    end

    def total_right_questions(tests)
      count = 0
      tests.each do |test|
        test[:questions].each do |question|
          if question[:correct] === true
            count = count + 1
          end
        end
      end
      count
    end

    def time_diff(statistics)
      start_d = statistics["user_created_at"]
      end_d = statistics["user_updated_at"]
      diff_time = Time.diff(start_d, end_d)
      diff_time[:diff]
    end
  end
end
