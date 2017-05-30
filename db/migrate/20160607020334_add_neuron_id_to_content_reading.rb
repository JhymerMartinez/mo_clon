class AddNeuronIdToContentReading < ActiveRecord::Migration
  def change
    say_with_time "WARNING: wiping all readings" do
      ContentReading.destroy_all
    end
    add_reference :content_readings,
                  :neuron,
                  null: false,
                  index: true,
                  foreign_key: true
  end
end
