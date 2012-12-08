// Generated by CoffeeScript 1.4.0
/*global define
*/

define(['d3layout'], function(d3) {
  'use strict';

  var draw, fontSize, hasChildren, maxLabelLength, nodeRadius;
  maxLabelLength = 30;
  nodeRadius = 5;
  fontSize = 12;
  draw = function(selector, data) {
    var $target, layoutRoot, leftOffset, link, links, nodeGroup, nodes, size, tree;
    $target = $(selector);
    leftOffset = hasChildren(data) ? data.name.length * 7 : 0;
    size = {
      width: $target.width(),
      height: $target.height()
    };
    tree = d3.layout.tree().size([size.height, size.width - leftOffset]).children(function(node) {
      if (!node.children || node.children.length === 0) {
        return null;
      } else {
        return node.children;
      }
    });
    nodes = tree.nodes(data);
    links = tree.links(nodes);
    layoutRoot = d3.select(selector).append('svg:svg').attr('width', size.width).attr('height', size.height).append('svg:g').attr('transform', 'translate(' + leftOffset + ',0)');
    link = d3.svg.diagonal().projection(function(node) {
      return [node.y, node.x];
    });
    layoutRoot.selectAll('path.link').data(links).enter().append('svg:path').attr('class', 'link').attr('d', link);
    nodeGroup = layoutRoot.selectAll('g.node').data(nodes).enter().append('svg:g').attr('class', 'node').attr('transform', function(node) {
      return 'translate(' + node.y + ',' + node.x + ')';
    });
    nodeGroup.append('svg:circle').attr('r', nodeRadius);
    return nodeGroup.append('svg:text').attr('text-anchor', function(d) {
      if (hasChildren(d)) {
        return 'end';
      } else {
        return 'start';
      }
    }).attr('dx', function(d) {
      if (hasChildren(d)) {
        return -2 * nodeRadius;
      } else {
        return 2 * nodeRadius;
      }
    }).attr('dy', 3).text(function(d) {
      return d.name;
    });
  };
  hasChildren = function(node) {
    return node.children && node.children.length > 0;
  };
  return {
    Draw: draw
  };
});
