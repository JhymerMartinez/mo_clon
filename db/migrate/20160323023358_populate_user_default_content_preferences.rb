class PopulateUserDefaultContentPreferences < ActiveRecord::Migration
  def up
    say_with_time "populating default content preferences for existing users" do
      User.find_each do |user|
        user.send :create_content_preferences!
      end
    end
  end

  def down
    say "nothing to do here"
  end
end
