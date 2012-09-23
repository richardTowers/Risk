// Generated by CoffeeScript 1.3.3
/*global require
*/

require.config({
  paths: {
    underscore: 'libs/underscore',
    bootstrap: 'libs/bootstrap',
    d3: 'libs/d3',
    d3layout: 'libs/d3.layout'
  },
  shim: {
    underscore: {
      exports: '_'
    },
    d3: {
      exports: 'd3'
    },
    d3layout: {
      deps: ['d3'],
      exports: 'd3'
    }
  }
});

require(['riskTree', 'bootstrap'], function(riskTree) {
  'use strict';
  $('#getRisk').click(function() {
    $('#alertNearlyThere').hide();
    $('#riskTree img').hide();
    $('#riskTree svg').remove();
    riskTree.Draw('#riskTree', 'flare.json');
    return $('#alertSuccess').show();
  });
});
