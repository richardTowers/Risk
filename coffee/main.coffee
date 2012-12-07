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
    
    successHandler = (data) ->
      # Hide the AJAX spinner
      $('.massiveSpinner').hide()
      # Hide the nearly there alert, since we are now *there*
      $('#alertNearlyThere').hide()
      # Hide the placeholder image
      $('#riskTree img').hide()
      # Remove any existing displays
      $('#riskTree svg').remove()
      # Make the drawing space massive
      $('#riskTree').height('2000px')
      # Draw the new tree
      riskTree.Draw '#riskTree', data
      # Show an alert to say we've been successful
      $('#alertSuccess').show()
      
    
    $('#getRisk').click () ->
      # Let the user know that something's going on, and stop them from
      # interacting with the page.
      $('.massiveSpinner').show()
      $('#getRisk').css 'disabled','disabled'
      
      # Make the AJAX call
      $.ajax 'flare.json',
        success: successHandler
    return