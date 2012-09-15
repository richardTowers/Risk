// Generated by CoffeeScript 1.3.3
/*global require, $
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
    d3layout: {
      deps: ['d3']
    }
  }
});

require(['text!../templates/navbar.html', 'text!../templates/header.html', 'text!../templates/loginform.html', 'underscore', 'bootstrap', 'riskTree'], function(navbar, header, loginform, _) {
  'use strict';
  $(function() {
    $('nav').html(_.template(navbar, {}));
    $('header').html(_.template(header, {}));
    return $('#loginform').html(_.template(loginform, {}));
  });
});
