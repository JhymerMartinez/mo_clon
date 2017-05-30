class Neuron < ActiveRecord::Base
  module Relationable
    RELATIONSHIPS = [
      :contents,
      :content_links,
      :content_medium,
      :content_videos
    ]

    def relationships_changed?
      RELATIONSHIPS.any? do |relationship|
        send("#{relationship}_any?", changed?: true)
      end
    end

    RELATIONSHIPS.each do |relationship|
      ##
      # if any of the contents matches the conditions
      #
      # @param opts [Hash] conditions to match
      # @example contents_any?({kind: kind})
      define_method "#{relationship}_any?" do |opts|
        send("#{relationship}_scope").any? do |item|
          opts.all? do |key, val|
            item.send(key).eql?(val)
          end
        end
      end
    end

    private

    def contents_scope
      contents
    end

    def content_links_scope
      contents.map(&:content_links).flatten
    end

    def content_medium_scope
      contents.map(&:content_medium).flatten
    end

    def content_videos_scope
      contents.map(&:content_videos).flatten
    end
  end
end
