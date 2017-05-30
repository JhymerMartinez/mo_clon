# If you use this, please uncomment `neography`
# from Gemfile

require "neography"
require "neo_importer/neuron_node"

class NeoImporter
  ROOT_ID = 13772

  def run!
    root = Neography::Node.load(ROOT_ID, neo)
    create_neuron!(root)
  end

  private

  def create_neuron!(node, parent=nil)
    neuron = NeuronNode.new(node, parent).create!
    node.outgoing(:is_father_of).each do |son|
      create_neuron!(son, neuron)
    end
  end

  def neo
    @neo ||= Neography::Rest.new(
      authentication: "basic",
      username: ENV["NEOUSER"] || "neo4j",
      password: ENV["NEOPASSWD"]
    )
  end
end
