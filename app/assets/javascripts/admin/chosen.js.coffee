applyChosen = ->
  # apply to all selects
  $("select").chosen allow_single_deselect: true

$(document).on "ready page:load", applyChosen
