require "rails_helper"

RSpec.describe Api::TreesController,
               type: :request do
  include RootNeuronMockable

  include_examples "requests:current_user"

  let!(:root) {
    root_neuron(
      create :neuron_visible_for_api
    )
  }

  let!(:root_learning) {
    # learn something on root so that
    # we can see root's children
    create :content_learning,
           user: current_user,
           content: root.contents.first
  }

  let(:response_root) {
    JSON.parse(response.body)
        .fetch("tree")
        .fetch("root")
  }

  # Las neuronas tienen los siguientes estados:
  # ND: No descubiertas
  # D: Descubiertas - aparecen en color gris (no tienen contenidos aprendidos)
  # F: Florecidas - aparecen con color. (al menos uno de sus contenidos fue aprendido (A) )
  describe "example tree" do
    # root
    #  /\
    # a *b
    #   /\
    #  c d
    #
    # *= al menos un contenido aprendido
    let!(:a) {
      create :neuron_visible_for_api,
             title: "a",
             parent: root
    }
    let!(:b) {
      create :neuron_visible_for_api,
             title: "b",
             parent: root
    }
    let!(:c) {
      create :neuron_visible_for_api,
             title: "c",
             parent: b
    }
    let!(:d) {
      create :neuron_visible_for_api,
             title: "d",
             parent: b
    }

    let!(:learning) {
      create :content_learning,
             user: current_user,
             content: b.contents.first
    }

    before { get "/api/tree" }

    it {
      a = child_by_title(response_root, "a")
      b = child_by_title(response_root, "b")
      c = child_by_title(b, "c")
      expect(a["state"]).to eq("descubierta")
      expect(b["state"]).to eq("florecida")
      expect(c["state"]).to eq("descubierta")
    }
  end
end

def child_by_title(parent, title)
  parent.fetch("children").detect do |child|
    child["title"] == title
  end
end
