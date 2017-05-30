class AddMediaToContent < ActiveRecord::Migration
  def change
    add_column :contents, :media, :string
  end
end
