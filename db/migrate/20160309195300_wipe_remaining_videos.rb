class WipeRemainingOldVideosTask
  attr_reader :video

  def initialize(video)
    @video = video
  end

  def self.run!
    scope = Content.where(kind: "videos")
    scope.find_each do |video|
      new(video).wipe!
    end
  end

  def wipe!
    reassign_keywords!
    log "wipe #{video.source} (##{video.neuron.id})"
    video.destroy
  end

  private

  def reassign_keywords!
    video.keywords.each do |keyword|
      log "[KEYWORD] assigning #{keyword} to content ##{target_content.id} #{target_content.title}"
      target_content.keyword_list << keyword.name
      target_content.save(validate: false)
    end
  end

  def log(str)
    puts str
    Rails.logger.info "[#{self.class}] #{str}"
  end

  def target_content
    other_contents.where(level: video.level).first || other_contents.first
  end

  def other_contents
    video.neuron.contents.where.not(id: video.id)
  end
end

class WipeRemainingVideos < ActiveRecord::Migration
  def up
    say_with_time "wiping remaining old videos and reassigning tags" do
      WipeRemainingOldVideosTask.run!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
