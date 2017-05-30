class AddFieldOrderToUserContentPreference < ActiveRecord::Migration
  def change
    add_column :user_content_preferences, :order, :integer
  end
end
