module ApplicationHelper
  ##
  # @param key [String] flash message key
  # @return [String] css class for a given flash
  #   key. This is considering we are using
  #   twitter bootstrap and it's default alerts
  def flash_message_class_for(key)
    case key
    when "notice"
      "success"
    when "error"
      "danger"
    when "alert"
      "warning"
    else
      key
    end
  end

  ##
  # Generates required markup to make a datatable.
  # @note Requires `:source` option
  #
  # @param options [Hash]
  # @yield Contents of the table
  # @option options [String] :source Source URL
  #   to fetch records from. Needs to respond
  #   to JSON
  # @option options [Boolean] :includes_actions (true)
  #   Option to make last column not sortable (So you
  #   can add actions in there)
  def datatable(options)
    defaults = { includes_actions: true }
    raise ArgumentError, ":source must be provided" if options[:source].blank?
    data = defaults.merge(options)
    content_tag :table, class: "datatable table table-striped", data: data do
      yield
    end
  end

  ##
  # Adds a tooltip. Accepts a block
  #
  # @param title [String]
  # @param options [Hash]
  # @option options [String] :place (top)
  # @option options [Symbol] :tag (:div)
  # @option options [Hash] :data
  # @yield a div with the tooltip
  def tooltip(title, options = {})
    opts = { place: "top", tag: :div }.merge(options)
    data = {
      toggle: "tooltip",
      placement: opts[:place]
    }.merge(opts.fetch(:data){ Hash.new })
    content_tag opts[:tag],
                class: "bs-tooltip #{opts[:class]}",
                title: title,
                data: data do
      yield
    end
  end

  ##
  # Renders a moi tree
  #
  # @param options [Hash]
  # @option options [String] :source where to pull
  #   neurons from. defaults to whole tree
  # @option options [Boolean] :hide_dialog (false)
  #   shows or hides dialog for each neuron
  def moi_tree(options={})
    defaults = {
      source: admin_neurons_path(format: :json)
    }
    opts = defaults.merge(options)
    opts[:source] ||= defaults[:source]
    render "admin/neurons/moi_tree/tree",
           options: opts
  end
end
