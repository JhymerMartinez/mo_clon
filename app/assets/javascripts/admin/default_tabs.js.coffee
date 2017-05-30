$(document).on "click", ".default-tabs a", (e) ->
  $this = $(this)
  $this.tab "show"
  if $this.hasClass("persist-tab")
    window.location.hash = $this.attr("href")

$(document).on "ready page:load", ->
  hash = window.location.hash

  # show first tab by default
  $(".default-tabs").each ->
    $(this).find("a:first").tab "show"

  if !!hash
    # attempt to set this hash as tab
    $(".default-tabs a[href='#{hash}']").tab "show"
