class AddMediaCountToContent < ActiveRecord::Migration
  def change
    add_column :contents, :media_count, :integer, default: 0
    add_index :contents, :media_count
  end
end
