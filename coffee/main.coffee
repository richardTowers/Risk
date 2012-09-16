###global require###

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
    d3:
      exports: 'd3'
    d3layout:
      deps: ['d3']
      exports: 'd3'
      
require [
  # Dependencies
  'underscore'
  'bootstrap',
  'riskTree'],
  () ->
    'use strict'
    return

#http://localhost:8888/Risk/Environment/DEVB/User/AHTEST01/LLJVMKY78/
#http://localhost:8888/Risk/Environment/DEVB/User/AHTEST01/LLJVMKY78/Contact/784567/Rfq/16549
#http://localhost:8888/Risk/Environment/DEVB/User/AHTEST01/LLJVMKY78/ExternalApplication/1753/richard.towers@acturis.com/ashdjkahsqwjdska/Contact/784567/Rfq/16549