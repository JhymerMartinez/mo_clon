class AddCompletedToContentLearningTest < ActiveRecord::Migration
  def change
    add_column :content_learning_tests, :completed, :boolean, default: false
    add_index :content_learning_tests, :completed
  end
end
