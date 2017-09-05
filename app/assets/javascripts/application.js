// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require svg.min.js
//= require jquery
//= require jquery_ujs
//= require jquery.minicolors
//= require turbolinks
//= require handlebars.runtime
//= require moment.langs
//= require moment-timezone-with-data-2010-2020
//= require datepicker
//= require jquery.hotkeys
//= require pnotify.custom.min
//= require jquery.fileDownload
//= require bootstrap
//= require jquery.cookie
//= require theme/jquery.backstretch.min
//= require twitter/typeahead.min
//= require bootstrap-tagsinput
//= require ember
//= require ember-data
//= require ember-simple-auth
//= require ember-simple-auth-oauth2
//= require autoNumeric
//= require underscore
//= require uuid
//= require_tree ./templates
//= require ../../../vendor/assets/javascripts/theme
//= require_self
//= require bodega


// for more details see: http://emberjs.com/guides/application/

Bodega = Ember.Application.create({
  classNames: ['full-height'],
  LOG_TRANSITIONS: true,
  DEBUG: true,
  LOG_VIEW_LOOKUPS: true
/*
  resolver: Ember.DefaultResolver.extend({
    resolveTemplate: function(parsedName) {
      parsedName.fullNameWithoutType = "templates/" + parsedName.fullNameWithoutType;
      return this._super(parsedName);
    }
  })
*/
});


// objeto con configuraciones varias
Bodega.Config = {
  perPage: 5 //items por página
};

// handler para cuando se presiona escape en la ventana de delete
Bodega.ignoreEscapeDeleteModalWindow = function(controller, route) {
  var e = window.event; 
  if(e.keyCode === 27){
    Bodega.__container__.lookup(controller).transitionToRoute(route);
    $('div.modal-backdrop.fade.in').detach();
  }
};

// handler para cuando se presiona un botón en el formulario de alta/edición
Bodega.keydownFormHandler = function(controllerID, action) {
  var e = window.event;
  if(e.keyCode === 121){ // F10 submitea el formulario
    var controller = Bodega.__container__.lookup(controllerID);
    var proxySend = jQuery.proxy(controller.send, controller);
    proxySend(action);
  }
};


Bodega.enterFormHandler = function(controllerID, action, params) {
  var e = window.event;
  if(e.keyCode === 13) { // enter
    var controller = Bodega.__container__.lookup(controllerID);
    var proxySend = jQuery.proxy(controller.send, controller);
    proxySend(action, params);
  }
};

// handler que ignora el botón enter
Bodega.ignoreEnter = function() {

  var event = window.event;
  if(event.keyCode == 13) {
      event.preventDefault();
      return false;
    }
};

Bodega.isAuthorized = function(recursoSolicitado, options) {
  var permisos = Ember.get(options.data.keywords.controller,'session.permisos');

  //Se vuelve a array los permisos en caso de que se haya vuelto cadena *un error cachiai*
  permisos = typeof permisos === "string" ? permisos.split(",") : permisos;
  permisos = permisos || [];

  var autorizado = false;
  //Se busca la coincidencia del recurso/accion.
  var autorizado = _.find(permisos, function(permiso) {   
    return permiso === recursoSolicitado
  });

  return autorizado;
}




