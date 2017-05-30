class User < ActiveRecord::Base
  module UserContentTasks

    def create_content_task(content_id)
      user_task = ContentTask.where(user_id: self.id, content_id: content_id)

      if user_task.empty?
        user_task = ContentTask.new(user_id: self.id, content_id: content_id)
        user_task.save
        false
      else
        true
      end

    end
  end
end
