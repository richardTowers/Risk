#<!-- JSHint directives are *not* annotations.
###global define###
#-->
# RiskTree
# ===================
# Handles drawing and updating a d3js tree diagram of the risk structure.

# Almost identical to [Mike Bostock](https://github.com/mbostock)'s [D3 tree example](http://mbostock.github.com/d3/talk/20111018/tree.html).
# I've converted to CoffeeScript and annotated the source, as well as doing some minor refactoring.

# Load the d3 libarary and the d3.layout plugin
define(['d3layout'], (d3) ->
  'use strict'
  
  # Constants
  # ---------------------
  maxLabelLength = 30
  nodeRadius = 5
  fontSize = 12
  
  # Draw
  # ---------------------
  #
  # Takes in a selector and some data and draws a
  # tree in the element the selector points at.
  draw = (selector, data) ->
    # First lets run the selector and store the result for later
    $target = $(selector)
    
    # We need to know the length of the first label so that we know how much space to leave on the left:
    leftOffset = if hasChildren(data) then data.name.length * 7 else 0
    
    # Get the size of the element
    size = 
      width: $target.width()
      height: $target.height()
    
    # Create the tree
    tree = d3.layout.tree()
      .size([size.height, size.width - leftOffset])
      .children (node) -> if (!node.children || node.children.length == 0) then null else node.children
    
    # Create the nodes and links
    nodes = tree.nodes data
    links = tree.links nodes
    
    # Add the top level SVG (i.e. a container `group`)
    layoutRoot = d3.select(selector)
      .append('svg:svg')
      .attr('width', size.width)
      .attr('height', size.height)
      .append('svg:g')
      # Budge the thing across by a bit
      .attr('transform', 'translate(' + leftOffset + ',0)')
    
    # Use the `diagonal` projection for links between nodes
    link = d3.svg.diagonal().projection (node) -> [node.y, node.x]
    
    # Draw the links
    layoutRoot.selectAll('path.link')
      .data(links)
      .enter()
      .append('svg:path')
      .attr('class', 'link')
      .attr('d', link)
    
    # Draw the nodes (groups to hold the text and circle)
    nodeGroup = layoutRoot.selectAll('g.node')
      .data(nodes)
      .enter()
      .append('svg:g')
      .attr('class', 'node')
      .attr('transform', (node) -> 'translate(' + node.y + ',' + node.x + ')')
    
    # Draw the circle
    nodeGroup.append('svg:circle')
      .attr('r', nodeRadius)

    # Draw the text
    nodeGroup.append('svg:text')
      # Text placement should depend on whether the node has any children
      .attr('text-anchor', (d) -> if hasChildren(d) then 'end' else 'start')
      .attr('dx', (d) -> if hasChildren(d) then -2*nodeRadius else 2*nodeRadius)
      .attr('dy', 3)
      .text((d) -> d.name)
  
  # Helper methods
  # --------------------
  hasChildren = (node) -> node.children and node.children.length > 0
    
  return { Draw: draw }    
)

# Todo
# ==================
# * Experiment with removing attributes from the SVG