class KnowledgeSearch
  elId: ".knowledge-search-form"
  resultsId: ".knowledge-search-results"
  templateId: "#knowledge-search-result-template"
  resultId: ".knowledge-search-result"

  constructor: ->
    @formListener()
    @resultListener()

  formListener: ->
    $(document).on "submit", @elId, @formSubmitted

  resultListener: ->
    $(document).on "click", @resultId, @resultSelected

  init: (@$input) ->
    # only show modal
    @$el = $(@elId)
    @$el.modal()
    @clear()

  clear: ->
    $(@resultsId).html ""

  formSubmitted: (e) =>
    $form = $(e.target)
    $.post $form.attr("action"), $form.serialize(), @gotResponse
    @showSpinner()
    false

  gotResponse: (data) =>
    template = Handlebars.compile $(@templateId).html()
    @hideSpinner()
    resultsHtml = template(data)
    $(@resultsId).html(resultsHtml)
    @reloadModal()

  reloadModal: ->
    @$el.modal "handleUpdate"

  resultSelected: (e) =>
    @showSpinner()
    src = $(e.currentTarget).data("href")
    iframe = $("<iframe />", src: src, html: "Can't load")
    iframe.on "load", @hideSpinner
    $results = $(@resultsId)
    externalLink = $("<a />", href: src, target: "_blank", html: src)
    $results.html iframe
    $results.append externalLink
    # @$input.attr "disabled", "disabled"
    @$input.val src
    @reloadModal()

  showSpinner: =>
    @$el.find(".loading-spinner").removeClass("hidden")

  hideSpinner: =>
    @$el.find(".loading-spinner").addClass("hidden")

knowledgeSearch = new KnowledgeSearch()

$(document).on "click", ".knowledge-search-btn", (e) ->
  $input = $(e.target).closest(".form-group")
                      .find "[name*='[source]']"
  knowledgeSearch.init $input
  false
