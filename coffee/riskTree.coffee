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
  
  # Helper methods
  # ---------------------
  hasChildren = (node) -> node.children and node.children.length > 0
  
  getLengthOfLongestLabelOnDeepestLevel = (() ->
    
    # This function will be called recursively for each branch of the tree.
    # We can keep it private to this closure.
    getDepthAndLength = (data, depth) ->
      # If `depth` is not provided, start with 1
      depth = 1 unless depth
      # `length` is the number of characters in the node's name
      length = data.name.length
      # If this node has no children then we already have the correct data for this branch.
      return [depth, length] unless hasChildren data
      # Otherwise we want the depth of the deepest child branch
      maxDepth = depth
      maxLength = length
      for child in data.children
        [newDepth, newLength] = getDepthAndLength child, depth + 1
        if newDepth > maxDepth
          maxDepth = newDepth
          maxLength = newLength
        else if newDepth == maxDepth and newLength > maxLength
          maxLength = newLength
      return [maxDepth, maxLength]
    
    # We're not actually interested in the `depth`, since d3 works all that out for us.
    # Return a wrapper that does not expose that information.
    return (data) ->
      [depth, length] = getDepthAndLength data
      return length
  )()

  # Draw
  # ---------------------
  #
  # Takes in a selector and some data and draws a
  # tree in the element the selector points at.
  draw = (selector, data) ->
    # First lets run the selector and store the result for later
    $target = $(selector)
    
    # We need to know the length of the first label so that we know how much space to leave on the left.
    leftOffset = if hasChildren(data) then data.name.length * 7 else 0
    
    # We also need to know the length of the longest label on the last row, so that we know how wide we can make the thing.
    maxLength = getLengthOfLongestLabelOnDeepestLevel data
    rightOffset = 40 + maxLength * 4
    
    # Get the size of the element
    size = 
      width: $target.width()
      height: $target.height()
    
    # Create the tree
    tree = d3.layout.tree()
      .size([size.height, size.width - leftOffset - rightOffset])
      .children (node) -> if hasChildren(node) then node.children else null 
    
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
    
  return { Draw: draw }    
)

# Todo
# ==================