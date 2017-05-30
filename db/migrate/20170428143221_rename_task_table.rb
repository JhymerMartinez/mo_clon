class RenameTaskTable < ActiveRecord::Migration
  def up
    rename_table :tasks, :content_tasks
  end
  def down
    rename_table :content_tasks, :tasks
  end
end
