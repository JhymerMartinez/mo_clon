module TreeService
  class ReadingTestFetcher
    MIN_COUNT_FOR_TEST = 4

    def initialize(user)
      @user = user
    end

    def perform_test?
      contents_for_test.count >= MIN_COUNT_FOR_TEST
    end

    def user_test_for_api
      return unless perform_test?
      @user_test ||= Api::LearningTestSerializer.new(
        test_creator.user_test,
        root: false
      )
    end

    private

    def test_creator
      LearningTestCreator.new(
        user: @user,
        contents: test_contents
      )
    end

    def test_contents
      contents_for_test.limit(MIN_COUNT_FOR_TEST)
    end

    def contents_for_test
      ContentsForTestFetcher.new(
        @user
      ).contents
    end
  end
end
