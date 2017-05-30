previewForm = (e) ->
  $this = $(this)
  $form = $this.closest "form"

  $submit = $form.find("input[type='submit']")
  originalSubmitVal = $submit.val()

  # modify form
  originalFormAction = $form.attr "action"
  $form.attr "action", $this.attr("href")
  $form.attr "target", "_blank"

  $form.submit()

  # restore form
  $form.attr "action", originalFormAction
  $form.removeAttr "target"

  # enable submit btn
  setTimeout ->
    $submit.removeAttr "disabled"
    $submit.val originalSubmitVal
  , 500

  # do not propagate
  false

$(document).on "click", "form .preview-btn", previewForm
