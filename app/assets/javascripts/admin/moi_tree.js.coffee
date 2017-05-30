#= require ./moi_tree/dialog

window.moiTree ||= {}

class moiTree.Tree
  selector: null
  $node: null
  path: null
  width: null
  height: null
  zoom: null
  diagonal: null
  initialTree: null

  constructor: (@selector) ->
    @$node = $(@selector)
    @node = @$node[0]
    @setZoom()
    @path = @$node.data("source")
    @width = @$node.width()
    @height = @width/2
    @createD3Elements()
    @drawSVG()
    @getNeurons()
    @listenForResize()

  listenForResize: ->
    $(window).on "resize", =>
      $chart = @$node.find("svg")
      targetWidth = $chart.parent().width()
      $chart.attr("width", targetWidth)
      $chart.attr("height", targetWidth / 2)

  createD3Elements: ->
    @tree = d3.layout.tree().size([@width, @height-20])
                            .nodeSize([80, 70])
    @diagonal = d3.svg.diagonal().projection((d) =>
      [ d.x, @height - d.y ]
    )

  setZoom: ->
    @zoom = d3.behavior.zoom().scaleExtent([0.0001,3])
                              .translate([380, -20])
                              .on('zoom', zoom)

  drawSVG: =>
    @svg = d3.select(@node)
              .append("svg")
              .attr("width", @width)
              .attr("height", @height)
              .style("overflow", "scroll")
              .append('g')
              .attr("class","drawarea")
              .attr("transform", "translate(#{@width / 2},-30)")
    d3.select('svg').call @zoom


  getNeurons: ->
    d3.json @path, @gotNeurons

  gotNeurons: (error, response) =>
    console.error(error) if error

    neurons = response.neurons # under `neurons` key in json

    @rootNeuron = neurons.filter((neuron) ->
      neuron.id == response.meta.root_id
    )[0]

    @initialTree = response.meta.initial_tree

    @rootNeuron.x0 = @height / 2;
    @rootNeuron.y0 = @width;

    @neuron_parents = { "no_parent":[] }

    for neuron in neurons
      if neuron.parent_id
        unless @neuron_parents[neuron.parent_id]
          @neuron_parents[neuron.parent_id] = []
        @neuron_parents[neuron.parent_id].push neuron
      else if neuron.id != response.meta.root_id
        @neuron_parents["no_parent"].push(neuron)

    @setChildren(@rootNeuron)

    @neurons = @tree.nodes(@rootNeuron)
    @update(@rootNeuron)
    @drawWithoutParent()

  redirectToNeuron: (neuron) =>
    window.location.pathname = "/admin/neurons/#{neuron.id}"

  drawWithoutParent: ->
    self = this
    vertical_space = 15
    no_parents = @svg.selectAll("g.no-parents")
                      .data(@neuron_parents["no_parent"])
                      .enter()
                      .append("g")
                      .attr("class", "node")
                      .attr("transform", (d, i) =>
                        y = i * vertical_space
                        "translate(#{@width - 10}, #{y})"
                      )
    no_parents.append("circle").attr "r", 4.5
    no_parents.append("text")
               .attr("dx", 8)
               .attr("dy", 3)
               .text((d) ->
                 d.title
               ).on("mouseenter", (node) ->
                 self.showDetails(node, this)
               ).on("click", @redirectToNeuron)

  setChildren: (neuron) ->
    # children are hidden by default...
    neuron.hidden_children = true
    neuron._children = @neuron_parents[neuron.id]
    if neuron is @rootNeuron # ... except for root
      neuron.hidden_children = false
      neuron.children = @neuron_parents[neuron.id]
      # manually trigger root as shown
      $(document).trigger "moiTree:nodeShown", neuron
    if neuron._children
      for child in neuron._children
        @setChildren(child)
        @showChildrenIfInitialTree(child)

  showChildrenIfInitialTree: (child) ->
    if child.id in @initialTree
      @showChildren(child)

  hideChildren: (node) ->
    node.hidden_children = true
    $(document).trigger "moiTree:nodeHidden", node
    return unless node.children
    node._children = node.children
    node.children = null
    for child in node._children
      @hideChildren(child)
    null

  showChildren: (node) ->
    node.hidden_children = false
    $(document).trigger "moiTree:nodeShown", node
    return unless node._children
    node.children = node._children
    node._children = null
    null

  nodeClicked: (node) =>
    @toggleNode node
    @update node
    false

  toggleNode: (node) ->
    if node.hidden_children
      @showChildren(node)
    else
      @hideChildren(node)
    @update(node)

  paintNodes: (node) ->
    node.attr('r', 4)
        .style('stroke', (d) ->
          if d.deleted then "#ec5747"
        )
        .style('fill', (d) ->
          if d.marked
            "orange"
          else if d.children || d._children is undefined
            "#fff"
          else
            "lightsteelblue"
        )

  update: (source) ->
    self = this
    duration = if d3.event and d3.event.altKey then 5000 else 500
    # Compute the new tree layout.
    nodes = @tree.nodes(@rootNeuron).reverse()
    # Normalize for fixed-depth.
    nodes.forEach (d) ->
      d.y = d.depth * 50
      return
    # Update the nodes…
    node = @svg.selectAll('g.node').data(nodes, (d) ->
      d.id or (d.id = ++i)
    )
    # Enter any new nodes at the parent's previous position.
    nodeEnter = node.enter().append('svg:g').attr('class', 'node').attr('transform', (d) ->
      'translate(' + source.y0 + ',' + source.x0 + ')'
    ).on('click', @nodeClicked)
    @paintNodes(nodeEnter.append('svg:circle'))

    nodeEnter.append('svg:text').attr('dy', -10).attr('text-anchor', 'middle').text((d) ->
      d.title
    ).on("mouseenter", (node) ->
      self.showDetails(node, this)
      )

    # Transition nodes to their new position.
    nodeUpdate = node.transition().duration(duration).attr('transform', (d) =>
      'translate(' + d.x + ',' + (@height - (d.y)) + ')'
    )
    @paintNodes(nodeUpdate.select('circle'))

    nodeUpdate.select('text').style('fill-opacity', 1)

    # Transition exiting nodes to the parent's new position.
    nodeExit = node.exit().transition().duration(duration).attr('transform', (d) ->
      'translate(' + source.y + ',' + source.x + ')'
    ).remove()
    nodeExit.select('circle').attr 'r', 4
    nodeExit.select('text').style 'fill-opacity', 1e-6
    # Update the links…
    link = @svg.selectAll('path.link').data(@tree.links(nodes), (d) ->
      d.target.id
    )
    # Enter any new links at the parent's previous position.
    link.enter().insert('svg:path', 'g').attr('class', 'link').attr('d', (d) =>
      o =
        x: source.x0
        y: source.y0
      @diagonal
        source: o
        target: o
    ).transition().duration(duration).attr 'd', @diagonal
    # Transition links to their new position.
    link.transition().duration(duration).attr 'd', @diagonal
    # Transition exiting nodes to the parent's new position.
    link.exit().transition().duration(duration).attr('d', (d) =>
      o =
        x: source.x
        y: source.y
      @diagonal
        source: o
        target: o
    ).remove()
    # Stash the old positions for transition.
    nodes.forEach (d) ->
      d.x0 = d.x
      d.y0 = d.y
      return
    return

  showDetails: (neuron, text) ->
    new moiTree.TreeDialog(neuron, text, @rootNeuron)

  zoom = ->
    $('.popover').hide()
    @m = [40, 240, 40, 240]
    @realWidth = 20000
    @realHeight = 2000
    @w = @realWidth - @m[0] - @m[0]
    @h = @realHeight - @m[0] - @m[2]
    scale = d3.event.scale
    translation = d3.event.translate
    tbound = -@h * scale
    bbound = @h * scale
    lbound = (-@w + @m[1]) * scale
    rbound = (@w - @m[3]) * scale
    # limit translation to thresholds
    translation = [
      Math.max(Math.min(translation[0], rbound), lbound)
      Math.max(Math.min(translation[1], bbound), tbound)
    ]
    d3.select('.drawarea').attr 'transform', 'translate(' + translation + ')' + ' scale(' + scale + ')'
    $(document).trigger "zoomChange", scale
    return

$(document).on "ready page:load", ->
  if $("#moi_tree").length > 0
    new moiTree.Tree("#moi_tree")
