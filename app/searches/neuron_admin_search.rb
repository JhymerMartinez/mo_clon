class NeuronAdminSearch < Searchlight::Search
  search_on Neuron.all
  searches :q

  def search_q
    search.includes(:contents)
          .where("neurons.title ILIKE :q OR contents.title ILIKE :q OR contents.description ILIKE :q", q: "%#{q}%")
          .references(:contents)
  end
end
