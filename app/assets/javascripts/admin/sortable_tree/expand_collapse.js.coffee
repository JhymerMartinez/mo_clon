wrapper = ".sortable-tree-actions"
sortableTreeWrapper = ".sortable-tree"

$(document).on "sortable_tree:shown", ->
  $(wrapper).show()

$(document).on "click", "#{wrapper} a", (e) ->
  action = $(e.currentTarget).data("action")
  if action == "expand"
    method = "addClass"
  else
    method = "removeClass"
  $("#{sortableTreeWrapper} li")[method]("active")
  false
