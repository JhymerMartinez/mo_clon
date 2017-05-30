formWrapper = ".contents_form"
currentHash = null

class NeuronTabSwitcher
  constructor: (hash) ->
    @id = Math.random()
    @hash = hash
    currentHash = hash
    @testContentPattern()
    @listenForHashUpdates()

  listenForHashUpdates: ->
    clickEvent = "click.NeuronTabSwitcher"
    $("#{formWrapper} .default-tabs").on clickEvent, (e) =>
      hash = $(e.target).attr("href")
      currentHash = hash

    $(document).on "page:before-unload", ->
      $("#{formWrapper} .default-tabs").off clickEvent

  testContentPattern: ->
    pattern = /content-/
    if pattern.test(@hash) # if it's showing any content
      @showCurrentContent()

  showCurrentContent: ->
    @showContentsTab()
    @showLevel()
    @showContent()

  showContentsTab: ->
    $("[href='#contents']").tab("show")

  showLevel: ->
    levelSubstr = "level-"
    index = @hash.indexOf(levelSubstr) + levelSubstr.length
    level = parseInt(@hash.substr(index, 1), 10)
    $pill = $("[href='#contents-level-#{level}']")
    $pill.siblings().removeClass "active"
    $pill.addClass "active"
    $pill.tab("show")

  showContent: ->
    $("[href='#{@hash}'").tab("show")

$(document).on "ready page:load", ->
  # store current hash
  currentHash = window.location.hash
  if $(formWrapper).length > 0
    new NeuronTabSwitcher(currentHash)

beforeUnloadEvent = "page:before-unload.NeuronTabSwitcher"
$(document).on beforeUnloadEvent, =>
  # apply old hash
  window.location.hash = currentHash
