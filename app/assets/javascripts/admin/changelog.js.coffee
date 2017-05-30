$(document).on "click", ".changelog-version", (e) ->

  # do not toggle if clicking on links or user img
  if e.target.tagName == "A" || e.target.tagName == "IMG"
    return true

  $details = $(this).find(".changeset-details")
  $details.slideToggle()
