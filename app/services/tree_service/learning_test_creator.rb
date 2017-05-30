module TreeService
  class LearningTestCreator
    def initialize(options)
      @user = options.fetch :user
      @contents = options.fetch :contents
    end

    def user_test
      @user_test ||= ContentLearningTest.create!(
        user: @user,
        questions: questions
      )
    end

    private

    def questions
      @contents.map do |content|
        {
          content_id: content.id,
          title: content.title,
          media_url: image_for(content),
          possible_answers: possible_answers_for(content)
        }
      end
    end

    def image_for(content)
      if content.media_count > 0
        content.content_medium.first.media_url
      end
    end

    def possible_answers_for(content)
      content.possible_answers.map do |possible_answer|
        possible_answer.attributes.slice(
          "id",
          "text",
          "correct"
        )
      end
    end
  end
end
