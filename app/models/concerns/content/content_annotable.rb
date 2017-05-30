class Content < ActiveRecord::Base
  module ContentAnnotable
    ##
    # @param user [User]
    # @return [ContentNote] notes by provided
    #   user (if any)
    def user_note(user)
      content_notes.find_by(
        user: user
      )
    end
  end
end
