class VideosMigrationTask
  attr_reader :video

  def initialize(video)
    @video = video
  end

  def self.run!
    scope = Content.where(kind: "videos")
    scope.find_each do |video|
      new(video).migrate!
    end
  end

  def migrate!
    log "migrating #{video_str}"
    if video.source.present?
      video.source.split(";")
                  .map(&:squish)
                  .reject(&:blank?).each do |url|
        target_content.content_videos.create!(url: url)
      end
    end
  end

  private

  def log(str)
    puts str
    Rails.logger.info "[#{self.class}] #{str}"
  end

  def video_str
    "#{video.source} - neuron ##{neuron.id} #{neuron}"
  end

  def neuron
    video.neuron
  end

  def target_content
    other_contents.where(level: video.level).first || other_contents.first || transform_video_content!
  end

  def transform_video_content!
    video.assign_attributes(
      title: "Vídeo recomendado",
      kind: Content::KINDS.first,
      source: ""
    )
    video.save(validate: false)
    video
  end

  def other_contents
    video.neuron.contents.where.not(id: video.id)
  end
end

class CreateContentVideos < ActiveRecord::Migration
  def up
    create_table :content_videos do |t|
      t.references :content,
                   null: false,
                   index: true,
                   foreign_key: true
      t.string :url, null: false
      t.timestamps null: false
    end

    say_with_time "migrating videos" do
      VideosMigrationTask.run!
    end
  end

  def down
    drop_table :content_videos
  end
end
