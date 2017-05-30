class AddFieldDeleteToContentTask < ActiveRecord::Migration
  def change
    add_column :content_tasks, :deleted, :boolean, default: false
  end
end
