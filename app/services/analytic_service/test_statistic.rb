module AnalyticService
  class TestStatistic
    def initialize(user)
      @user = user
    end

    def results
      user_tests = ContentLearningTest.where(user: @user)
      user_tests_formated = user_tests.map do |test|
        questions_formated = test["questions"].map do |question|
          if test["answers"]
            answer = test["answers"].detect {|a| a["content_id"] == question["content_id"]}
            {
              content_id: question["content_id"],
              content_title: question["title"],
              correct: answer["correct"]
            }
          else
            {
              content_id: question["content_id"],
              content_title: question["title"],
              correct: nil
            }
          end
        end
        {
          test_id: test["id"],
          questions: questions_formated
        }
      end
    end
  end
end
