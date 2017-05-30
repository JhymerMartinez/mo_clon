require "uri"

class NeoImporter
  class FixLegacyMedia
    def run!
      Content.paper_trail_off!
      Content.find_each do |content|
        media = content.read_attribute(:media)
        if media.present? && media.include?("/uploads")
          uri = host + media
          begin
            content.remote_media_url = uri
            content.save
          rescue OpenURI::HTTPError => e
            puts "- UPS!: #{uri}"
          end
        end
      end
      Content.paper_trail_on!
    end

    private

    def host
      ENV["HOST"]
    end
  end
end
