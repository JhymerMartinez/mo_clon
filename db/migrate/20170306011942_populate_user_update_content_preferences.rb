class PopulateUserUpdateContentPreferences < ActiveRecord::Migration
  def up
    say_with_time "assign order content preferences for existing users" do
      User.find_each do |user|
        user.send :assign_order_content_preferences!
      end
    end
  end

  def down
    say "nothing to do here"
  end
end
