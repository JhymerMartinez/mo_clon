# update content's test title based on
# current input's value

titleSelector = ".content-title"

$(document).on "keyup", titleSelector, (e) ->
  $input = $(e.currentTarget)
  $input.parents(".content-form")
        .find(".test-question")
        .text $input.val()
