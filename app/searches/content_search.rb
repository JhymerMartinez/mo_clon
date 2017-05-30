class ContentSearch < Searchlight::Search
  search_on Content.all
  searches :q

  def search_q
    search.where("unaccent(contents.title) ILIKE :q OR unaccent(contents.description) ILIKE :q", q: "%#{q}%")
          .where(['approved', true])
  end
end
