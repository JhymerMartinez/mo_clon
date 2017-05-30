class CopyContentTitles < ActiveRecord::Migration
  def up
    PaperTrail.enabled = false

    say_with_time "updating contents.." do
      Content.find_each do |content|
        content_parts = content.description.split("\n")
        has_title = content_parts.length >= 3 && content_parts[1].blank?
        if has_title
          title = content_parts[0] # first is title
          say "updated content ##{content.id} -> #{title}"
          content_parts.slice!(0,2) # remove first two
          description = content_parts.join("\n") # rejoin the rest
          content.assign_attributes(
            title: title,
            description: description
          )
          content.save(validate: false)
        end
      end
    end

    PaperTrail.enabled = true
  end

  def down
    say_with_time "wat" do
      PaperTrail.enabled = false

      Content.find_each do |content|
        if content.title.present?
          description = content.title + "\n\n" + content.description
          content.assign_attributes(
            description: description
          )
          content.save validate: false
        end
      end

      PaperTrail.enabled = true
    end
  end
end
