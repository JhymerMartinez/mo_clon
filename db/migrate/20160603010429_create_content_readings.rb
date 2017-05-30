class CreateContentReadings < ActiveRecord::Migration
  def change
    create_table :content_readings do |t|
      t.references :user,
                   null: false,
                   index: true,
                   foreign_key: true
      t.references :content,
                   null: false,
                   index: true,
                   foreign_key: true
      t.timestamps null: false
    end

    say_with_time "WARNING: dropping all content learnings" do
      ContentLearning.destroy_all
    end
  end
end
