class NeoImporter
  class NeuronNode
    attr_reader :node, :parent

    def initialize(node, parent=nil)
      @node = node
      @parent = parent
    end

    def create!
      create_neuron!.tap do |neuron|
        levels.each do |level|
          kinds.each do |kind|
            attributes = content_attributes_for(level, kind)

            if attributes[:description].present? || attributes[:source].present?
              neuron.contents.create!(attributes)
            else
              # puts "WARN: Discarding content:"
              # puts attributes
            end
          end
        end
      end
      puts "Created: #{@created_neuron.title}, parent: #{@created_neuron.parent.try(:title)}"
      @created_neuron
    end

    private

    def content_attributes_for(level, kind)
      klass = mapping.fetch(kind)
      prefix = "level#{level}_#{klass}"

      return {
        level: level,
        kind: kind,
        description: description_for(prefix, level, kind),
        source: node.send("#{prefix}_source_link"),
        media: node.send("#{prefix}_photo"),
        keyword_list: node.send("keywords").to_s.split(",")
      }
    end

    def description_for(prefix, level, kind)
      description = ""

      # add title just in case
      title = node.send("#{prefix}_title")
      if title.present?
        description = "#{title}\n\n"
      end

      description + node.send("#{prefix}_description").to_s
    end

    def create_neuron!
      title = node.name

      dup_i = 1
      while Neuron.exists?(title: title)
        title = "#{node.name} (DUP #{dup_i})"
        dup_i += 1
      end

      @created_neuron = Neuron.create!(
        title: title,
        parent_id: parent.try(:id)
      )
    end

    def levels
      1..3
    end

    def kinds
      Content::KINDS
    end

    def mapping
      @mapping ||= {
        :"que-es" => "what",
        :"por-que-es" => "why",
        :"como-funciona" => "how",
        :"enlaces" => "links",
        :"quien-cuando-donde" => "qcd",
        :"videos" => "videos"
      }
    end
  end
end
