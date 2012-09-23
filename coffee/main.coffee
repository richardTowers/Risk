#<!--
###global require###
#-->
# Main
#==================
# A single entry point. Sets up dependecies and
# builds the necessary models and views.

# Setup Require
require.config
  paths:
    underscore: 'libs/underscore'
    bootstrap: 'libs/bootstrap'
    d3: 'libs/d3'
    d3layout: 'libs/d3.layout' 
  shim:
    underscore:
      exports: '_'
    d3:
      exports: 'd3'
    d3layout:
      deps: ['d3']
      exports: 'd3'
      
require [
  # Dependencies
  'riskTree'
  'bootstrap'],
  (riskTree) ->
    'use strict'
    $('#getRisk').click () ->
      # Hide the nearly there alert, since we are now *there*
      $('#alertNearlyThere').hide()
      # Hide the placeholder image
      $('#riskTree img').hide()
      # Remove any existing displays
      $('#riskTree svg').remove()
      # Draw the new tree
      riskTree.Draw '#riskTree', 'flare.json'
      # Show an alert to say we've been successful
      $('#alertSuccess').show()
    return