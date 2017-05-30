# automatically adds level and kind to content form
$(document).on "nested:fieldAdded:contents", (e) ->
  $contentForm = e.field
  $target = $(e.currentTarget.activeElement)
  $contentForm.find("input.content-level")
              .val $target.data("level")
  $contentForm.find("input.content-kind")
              .val $target.data("kind")
