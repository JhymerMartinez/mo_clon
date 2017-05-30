placeholder = ".sortable-tree-placeholder"

isUpdating = false

reorder_neurons = (newTree) ->
  isUpdating = true
  NProgress.start()
  $(".sortable-tree-status").html "Actualizando.."
  $.post "/admin/neurons/reorder", tree: newTree, (r) ->
    NProgress.done()
    isUpdating = false
    $(".sortable-tree-status").html ""

$(document).on "click", ".sortable-tree li .toggle-children", (e) ->
  $(e.currentTarget).parent().toggleClass "active"

loadSortableTree = ->
  isUpdating = false

  $container = $(".sortable-tree")

  if $(placeholder).length > 0
    NProgress.start()
    $container.load "/admin/neurons/sorting_tree", ->
      $(document).trigger "sortable_tree:shown"
      NProgress.done()
      $(placeholder).remove()
      $container.sortable
        onDrop: ($item, container, _super) ->
          data = $container.sortable("serialize").get()
          jsonString = JSON.stringify(data, null)
          reorder_neurons jsonString
          _super($item, container)
        onMousedown: ->
          return !isUpdating # do not update twice

$(document).on "ready page:load", loadSortableTree
