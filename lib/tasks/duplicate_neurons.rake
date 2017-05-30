require "duplicate_neurons_task"

namespace :duplicate_neurons do
  desc "list all duplicate neurons to remove"
  task list: :environment do
    DuplicateNeuronsTask.list
  end

  desc "wipe all duplicate neurons"
  task wipe: :environment do
    DuplicateNeuronsTask.wipe_all!
  end
end
