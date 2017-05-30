applyTooltips = ($scope) ->
  $scope.find(".bs-tooltip").tooltip()

$(document).on "ready page:load", ->
  applyTooltips $("body")

$(document).on "nested:fieldAdded", (e) ->
  applyTooltips e.field
