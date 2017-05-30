selector = ".input-tags"
$(document).on "ready page:load nested:fieldAdded:contents", ->
  $(selector).tagsinput
    tagClass: "label label-info"
