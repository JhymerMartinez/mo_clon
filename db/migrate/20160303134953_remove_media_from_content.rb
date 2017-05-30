class RemoveMediaFromContent < ActiveRecord::Migration
  def up
    remove_column :contents, :media
  end

  def down
    add_column :contents, :media, :string
  end
end
