class NeuronDecorator < LittleDecorator
  def parent_title
    parent.try :title
  end

  def parent
    @parent ||= Neuron.find(
      parent_id
    ) if parent_id.present?
  end

  def contents_to_approve_badge
    contents_badge(
      content: contents_to_approve_count,
      class: "warning",
      title: t("views.neurons.contents") + " " + t("views.contents.to_approve").downcase
    )
  end

  def contents_approved_badge
    contents_badge(
      content: contents_approved_count,
      class: "info",
      title: t("views.neurons.contents") + " " + t("views.contents.approved_status.approved").pluralize.downcase
    )
  end

  def status_label
    type = is_public ? "success" : "default"
    content_tag :span,
                class: "label label-#{type}" do
      I18n.t("views.neurons.public_status.#{is_public}")
    end
  end

  def deleted_label
    content_tag :span,
                class: "label label-danger" do
      I18n.t("views.neurons.delete")
    end
  end

  private

  def contents_badge(options)
    content_tag :span,
                options[:content],
                class: "bs-tooltip btn-xs no-link bg-#{options[:class]}",
                title: options[:title],
                data: { placement: "bottom" }
  end

  def contents_to_approve_count
    record.contents.approved(:false).count
  end

  def contents_approved_count
    record.contents.approved.count
  end
end
