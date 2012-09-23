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
      $('#alertNearlyThere').hide()
      $('#riskTree img').hide()
      $('#alertSuccess').show()
      riskTree.Draw '#riskTree', 'flare.json'
    return