$(document).on "click", ".default-list-group a", (e) ->
  $this = $(this)
  $this.parent().find("a").removeClass "active"
  $this.addClass "active"
  $this.tab "show"

$(document).on "ready page:load", ->
  # show first default list group by default
  $(".default-list-group").each ->
    $(this).find("a:first").addClass("active")
                           .tab "show"
