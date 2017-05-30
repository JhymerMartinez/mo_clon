class LinksMigrationTask
  attr_reader :link

  def initialize(link)
    @link = link
  end

  def self.run!
    scope = Content.where(kind: "enlaces")
    scope.find_each do |link|
      new(link).migrate!
    end
  end

  def migrate!
    log "migrating #{link_str}"
    target_content.content_links.create!(
      link: link.source
    )
  end

  private

  def log(str)
    puts str
    Rails.logger.info "[#{self.class}] #{str}"
  end

  def link_str
    "#{link.source} - level #{link.level} - neuron ##{neuron.id} #{neuron}"
  end

  def neuron
    link.neuron
  end

  def target_content
    other_contents.where(level: link.level).first || other_contents.first
  end

  def other_contents
    link.neuron.contents.where.not(id: link.id)
  end
end

class CreateContentLinks < ActiveRecord::Migration
  def up
    create_table :content_links do |t|
      t.references :content,
                   null: false,
                   index: true,
                   foreign_key: true
      t.string :link, null: false
      t.timestamps null: false
    end

    say_with_time "migrating links" do
      LinksMigrationTask.run!
    end
  end

  def down
    drop_table :content_links
  end
end
