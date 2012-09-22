#<!-- JSHint directives are *not* annotations.
###global require###
#-->
# RiskTree
# ===================
# Handles drawing and updating a d3js tree diagram of the risk structure.

# Almost identical to [Mike Bostock](https://github.com/mbostock)'s [D3 tree example](http://mbostock.github.com/d3/talk/20111018/tree.html).
# I've converted to CoffeeScript and annotated the source, as well as doing some minor refactoring.

# Load the d3 libarary and the d3.layout plugin
require(['d3layout'], (d3) ->
  "use strict"
  
  # Constants
  # ---------------------
  
  # Transition duration (for expanding and collapsing nodes)
  duration = 500
  # Layer spacing (pixels)
  spacing = 180
  # Circle size
  circleRadius = 4.5
  # Fill Color (collapsed)
  collapsedFillColor = "salmon"
  # Fill Color (expanded)
  expandedFillColor = "#fff"
  # Margins
  margin =
    top: 20
    left: 120
    bottom: 20
    right: 120
  # Total Size
  totalWidth = 1130
  totalHeight = 1000
  
  # Calculate derived values
  width = totalWidth - margin.left - margin.right
  height = totalHeight - margin.top - margin.bottom
  
  # Main
  # ---------------------
  # Sets up the visualization and makes the first call to `update`
  
  # Create an SVG container for the tree
  vis = d3.select("#riskTree")
    .append("svg:svg")
    .attr("width", totalWidth)
    .attr("height", totalHeight)
    .append("svg:g")
    .attr("transform", "translate(" + margin.right + "," + margin.top + ")")
  
  # The root node
  root = null
  # Load up the data and make the first call to update
  d3.json "flare.json", (json) ->
    root = json
    root.x0 = height / 2
    root.y0 = 0
    update root
  
  # Utilities
  # ---------------------
  
  # A diagonal projection to use for transistions
  diagonal = d3.svg
    .diagonal()
    .projection((d) -> [d.y, d.x])
  
  # D3 tree layout
  tree = d3.layout
    .tree()
    .size([height, width])
  
  # Update
  # ---------------------
  # A function to redraw the tree object after its state has changed.
  
  # Iterator to keep track of ids
  # (we need to keep this in a higher scope so that it persists between calls to update)
  i = 0
  
  update = (source) ->
    # Populate the tree layout with our nodes
    nodes = tree.nodes(root)
    
    # Set the horizontal position of each node
    nodes.forEach (d) ->
      d.y = d.depth * spacing
    
    # Give each node a unique id
    node = vis.selectAll("g.node")
      .data(nodes, (d) -> d.id or (d.id = ++i))
    
    # At the top level, nodes are SVG groups. Circles and text are drawn within the group.
    nodeInner = node.enter()
      .append("svg:g")
      .attr("class", "node")
      .attr("transform", () ->
        "translate(" + source.y0 + "," + source.x0 + ")")
      .on("click", (d) ->
        toggle d
        update d)
    
    # Add the circle to the node
    nodeInner.append("svg:circle")
      .attr("r", 1e-6)
      .style "fill", (d) -> (if d._children then collapsedFillColor else expandedFillColor)
    
    # Add the text to the node
    nodeInner.append("svg:text")
      .attr("x", (d) -> (if d.children or d._children then -10 else 10))
      .attr("dy", ".35em")
      .attr("text-anchor", (d) -> (if d.children or d._children then "end" else "start"))
      .text((d) -> d.name)
      .style "fill-opacity", 1e-6
    
    # Transition the node to its display position
    nodeUpdate = node.transition()
      .duration(duration)
      .attr("transform", (d) -> "translate(" + d.y + "," + d.x + ")")
    
    # Show the circle
    nodeUpdate.select("circle")
      .attr("r", circleRadius)
      .style "fill", (d) -> (if d._children then collapsedFillColor else expandedFillColor)
    
    # Show the text
    nodeUpdate.select("text")
      .style "fill-opacity", 1
    
    # Transition the node to its starting position and remove it
    nodeExit = node.exit()
      .transition()
      .duration(duration)
      .attr("transform", () -> "translate(" + source.y + "," + source.x + ")")
      .remove()
    
    # Hide the circle
    nodeExit.select("circle")
      .attr "r", 1e-6
    
    # Hide the text
    nodeExit.select("text")
      .style "fill-opacity", 1e-6
    
    link = vis.selectAll("path.link")
      .data(tree.links(nodes), (d) -> d.target.id)
    
    link.enter()
      .insert("svg:path", "g")
      .attr("class", "link")
      .attr("d", () ->
        o =
          x: source.x0
          y: source.y0
        diagonal {source: o,target: o})
      .transition()
      .duration(duration)
      .attr "d", diagonal
    
    link.transition()
      .duration(duration)
      .attr "d", diagonal
    
    link.exit()
      .transition()
      .duration(duration)
      .attr("d", () ->
        o =
          x: source.x0
          y: source.y0
        diagonal {source: o,target: o})
      .remove()
    
    nodes.forEach (d) ->
      d.x0 = d.x
      d.y0 = d.y
      
  # Toggle
  # ---------------------
  # Toggle the visibility of this node's children
  
  # Note: You will have to call `update` to display the changes.  
  toggle = (d) ->
    if d.children
      d._children = d.children
      d.children = null
    else
      d.children = d._children
      d._children = null
  
  return
)