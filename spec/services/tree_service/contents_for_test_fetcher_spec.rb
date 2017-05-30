require "rails_helper"

RSpec.describe TreeService::ContentsForTestFetcher,
               %Q{
Las neuronas tienen los siguientes estados:

ND: No descubiertas
D: Descubiertas - aparecen en color gris (no tienen contenidos aprendidos)
F: Florecidas - aparecen con color. (al menos uno de sus contenidos fue aprendido (A) )
               },
               type: :model do
  let(:current_user) { create :user }

  subject {
    TreeService::ContentsForTestFetcher.new(
      current_user
    ).contents
  }

  describe "un usuario lee un contenido de una neurona en la que su neurona madre tiene estado F" do
    let!(:madre) {
      create :neuron_visible_for_api
    }
    let!(:learning) {
      # el usuario la va a leer antes
      create :content_reading,
             user: current_user,
             content: madre.contents.first
      # una neurona florecida es cuando al
      # menos uno de sus contenidos fue
      # aprendido
      create :content_learning,
             user: current_user,
             content: madre.contents.first
    }
    let!(:neuron) {
      create :neuron_visible_for_api,
             parent: madre
    }
    let!(:reading) {
      create :content_reading,
             user: current_user,
             content: neuron.contents.first
    }
    let!(:other_neuron) {
      create :neuron_visible_for_api,
             parent: madre
    }

    it {
      is_expected.to include(
        reading.content
      )
    }
    it {
      is_expected.to_not include(
        other_neuron.contents.first
      )
    }
    it "shouldn't include already-learnt content" do
      is_expected.to_not include(
        learning.content
      )
    end
  end

  describe "un usuario lee un contenido de una neurona que ya tiene un estado F" do
    let!(:madre) {
      create :neuron_visible_for_api
    }
    let!(:learning) {
      # una neurona florecida es cuando al
      # menos uno de sus contenidos fue
      # aprendido
      create :content_learning,
             user: current_user,
             content: madre.contents.first
    }
    let!(:reading_content) {
      create :content, :approved, neuron: madre
    }
    let!(:reading) {
      create :content_reading,
             user: current_user,
             content: reading_content
    }
    let!(:other_content) {
      create :content, :approved, neuron: madre
    }

    it {
      is_expected.to include(reading_content)
    }
    it {
      is_expected.to_not include(other_content)
    }
  end

  describe "al leer 4 contenidos de una neurona" do
    let!(:madre) {
      create :neuron_visible_for_api
    }
    let!(:contents) {
      4.times.map do
        create :content, :approved, neuron: madre
      end
    }
    let!(:readings) {
      contents.map do |content|
        create :content_reading,
               content: content,
               user: current_user
      end
    }

    it {
      contents.map do |content|
        is_expected.to include(content)
      end
    }
  end
end
