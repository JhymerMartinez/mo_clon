class AddNeuronIdToContentLearning < ActiveRecord::Migration
  def change
    say_with_time "WARNING: wiping all learnings" do
      ContentLearning.destroy_all
    end
    add_reference :content_learnings,
                  :neuron,
                  null: false,
                  index: true,
                  foreign_key: true
  end
end
