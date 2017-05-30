selector = "form.neuron-form"
formHasChanged = false
formData = null

$(document).on "ready page:load", ->
  formHasChanged = false
  formData = $(selector).serialize()

$(document).on "change", "#{selector} input, #{selector} textarea", ->
  newData = $(selector).serialize()
  formHasChanged = formData != newData

$(document).on "page:before-change", ->
  confirm(
    "La información no ha sido guardada. ¿Estás seguro de continuar?"
  ) if formHasChanged
