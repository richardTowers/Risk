###global require###

# RiskTree
# ===================
# Handles drawing and updating a d3js tree diagram of the risk structure.

# Load the d3 libarary and the d3.layout plugin
require(['d3layout'], (d3) ->
  "use strict"
  
  # Update
  # ---------------------
  # A function to redraw the tree object after its state has changed.
  
  update = (source) ->
    duration = 500
    
    nodes = tree.nodes(root)
    
    nodes.forEach (d) ->
      d.y = d.depth * 180

    node = vis.selectAll("g.node")
      .data(nodes, (d) -> d.id or (d.id = ++i))
    
    nodeEnter = node.enter()
      .append("svg:g")
      .attr("class", "node")
      .attr("transform", () ->
        "translate(" + source.y0 + "," + source.x0 + ")")
      .on("click", (d) ->
        toggle d
        update d)
        
    nodeEnter.append("svg:circle")
      .attr("r", 1e-6)
      .style "fill", (d) -> (if d._children then "salmon" else "#fff")

    nodeEnter.append("svg:text")
      .attr("x", (d) -> (if d.children or d._children then -10 else 10))
      .attr("dy", ".35em")
      .attr("text-anchor", (d) -> (if d.children or d._children then "end" else "start"))
      .text((d) -> d.name)
      .style "fill-opacity", 1e-6
    
    nodeUpdate = node.transition()
      .duration(duration)
      .attr("transform", (d) -> "translate(" + d.y + "," + d.x + ")")
    
    nodeUpdate.select("circle")
      .attr("r", 4.5)
      .style "fill", (d) -> (if d._children then "salmon" else "#fff")

    nodeUpdate.select("text")
      .style "fill-opacity", 1
    
    nodeExit = node.exit()
      .transition()
      .duration(duration)
      .attr("transform", () -> "translate(" + source.y + "," + source.x + ")")
      .remove()
      
    nodeExit.select("circle")
      .attr "r", 1e-6
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
  
  margin =
    top: 20
    left: 120
    bottom: 20
    right: 120
  
  width = 1130 - margin.left - margin.right
  height = 1000 - margin.top - margin.bottom
  i = 0
  root = undefined
  tree = d3.layout.tree().size([height, width])
  diagonal = d3.svg
    .diagonal()
    .projection((d) -> [d.y, d.x])
    
  vis = d3.select("#riskTree")
    .append("svg:svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("svg:g")
    .attr("transform", "translate(" + margin.right + "," + margin.top + ")")
    
  d3.json "flare.json", (json) ->
    toggleAll = (d) ->
      if d.children
        d.children.forEach toggleAll
        toggle d
    root = json
    root.x0 = height / 2
    root.y0 = 0
    update root
)