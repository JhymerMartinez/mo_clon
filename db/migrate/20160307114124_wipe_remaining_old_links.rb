class WipeRemainingOldLinksTask
  attr_reader :link

  def initialize(link)
    @link = link
  end

  def self.run!
    scope = Content.where(kind: "enlaces")
    scope.find_each do |link|
      new(link).wipe!
    end
  end

  def wipe!
    reassign_keywords!
    log "wipe #{link.source} (##{link.neuron.id})"
    link.destroy
  end

  private

  def reassign_keywords!
    link.keywords.each do |keyword|
      log "[KEYWORD] assigning #{keyword} to content ##{target_content.id} #{target_content.title}"
      target_content.keyword_list << keyword.name
      target_content.save!
    end
  end

  def log(str)
    puts str
    Rails.logger.info "[#{self.class}] #{str}"
  end

  def target_content
    other_contents.where(level: link.level).first || other_contents.first
  end

  def other_contents
    link.neuron.contents.where.not(id: link.id)
  end
end

class WipeRemainingOldLinks < ActiveRecord::Migration
  def up
    say_with_time "wiping remaining old links and reassigning tags" do
      WipeRemainingOldLinksTask.run!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
