window.moiTree ||= {}

currentTreeZoom = 1

$(document).on "zoomChange", (e, scale) =>
  currentTreeZoom = scale

class moiTree.TreeDialog
  constructor: (@neuron, @text, @rootNeuron) ->
    @$popover = $(".popover")
    @positionPopover()
    @setTitle()
    @setShowLink()
    @setNewChildLink()
    @setEditLink()
    @setToggleLink()

  setShowLink: ->
    href = "/admin/neurons/#{@neuron.id}"
    @$popover.find(".show-link")
             .attr("href", href)

  setTitle: ->
    @$popover.find(".popover-title")
             .html(@neuron.title)

  setNewChildLink: ->
    $link = @$popover.find(".new-child-link")
    if @neuron.parent_id or @neuron.id == @rootNeuron.id
      href = "/admin/neurons/new?parent_id=#{@neuron.id}"
      $link.show().attr("href", href)
    else
      $link.hide()

  setEditLink: ->
    href = "/admin/neurons/#{@neuron.id}/edit"
    @$popover.find(".edit-link")
             .attr("href", href)

  setToggleLink: ->
    $deleteLink = @$popover.find(".destroy-link")
    $restoreLink = @$popover.find(".restore-link")
    if @neuron.deleted
      $restoreLink.show()
      $restoreLink.attr("href", "/admin/neurons/#{@neuron.id}/restore")
      $deleteLink.hide()
    else
      $deleteLink.show()
      $deleteLink.attr("href", "/admin/neurons/#{@neuron.id}/delete")
      $restoreLink.hide()

  positionPopover: ->
    $text = $(@text)
    position = $text[0].getBoundingClientRect();
    left = position.left + 5 # 5 is just padding
    leftOffset = $text[0].getBBox().width # this gets the width of svg
    leftFinal = left + (leftOffset * currentTreeZoom)

    # position box itself
    @$popover.removeClass("hidden")
             .hide()
             .fadeIn(300)
             .css(
               position: "absolute",
               left: leftFinal,
               top: position.top - 17
             )

    # move arrow
    @$popover.find(".arrow")
             .css(
               position: "absolute",
               top: "20px"
             )

# close popover
$(document).on "click", ".popover .close", ->
  $(".popover").fadeOut(200)
