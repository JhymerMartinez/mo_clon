class ApprovedContent < ActiveRecord::Migration
  def up
    add_column :contents, :approved, :boolean, default: false
  end

  def down
    remove_column :contents, :approved
  end
end
