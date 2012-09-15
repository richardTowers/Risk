###global require, $###

# Main
#==================
# A single entry point. Sets up dependecies and
# builds the necessary models and views.
require.config
  paths:
    underscore: 'libs/underscore'
    bootstrap: 'libs/bootstrap'
    d3: 'libs/d3'
    d3layout: 'libs/d3.layout' 
  shim:
    underscore:
      exports: '_'
    d3layout:
      deps: ['d3']
      
require [
  # Templates
  'text!../templates/navbar.html'
  'text!../templates/header.html'
  'text!../templates/loginform.html'
  # Dependencies
  'underscore'
  'bootstrap',
  'riskTree'],
  (navbar, header, loginform, _) ->
    'use strict'
    $ () ->
      # Render the templates
      $('nav').html(_.template(navbar, {}))
      $('header').html(_.template(header, {}))
      $('#loginform').html(_.template(loginform, {}))
    return