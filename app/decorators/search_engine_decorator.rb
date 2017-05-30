class SearchEngineDecorator < LittleDecorator
  delegate :to_s, to: :record

  def status_label
    type = active ? "success" : "default"
    content_tag :span,
                class: "label label-#{type} search-engine-status" do
      I18n.t("views.search_engine.active_status.#{active}")
    end
  end
end
