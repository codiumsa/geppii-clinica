/*global Bodega, Ember, Bloodhound, $, console */
/**
 * Input integrado con typeahead.js
 *
 * @author Jorge Ramírez <jorge@codium.com.py>
 **/
(function() {
  'use strict';

  Bodega.SearchInputComponent = Ember.TextField.extend({

    attributeBindings: ['autofocus'],

    // nombre del atributo que se mostrará en el resultado de las búsquedas
    property: '',

    // referencia a la sesión
    session: null,

    // nombre del servicio a utilizar para recuperar las opciones
    service: '',

    apiNamespace: '/api/v1/',

    // scope de búsqueda utilizado para las consultas
    queryScope: 'by_descripcion',

    // nombre del modelo
    modelType: '',

    // atributo que representa al ID en el modelo
    modelID: 'id',

    // root de la respuesta del servidor
    jsonRoot: '',

    // referencia al store asociado al controlador
    store: null,

    // elemento actualment seleccionado
    selectedItem: null,

    // lista de atributos del modelo, separados por coma, que deben ignorarse para
    // que funcione la normalización del json. Por lo general solo las relaciones
    // son necesarias incluir en el listado.
    ignoredProperties: null,

    configureSearchInput: function() {

      if(this.get('autofocus')){
        this.$().focus();
      }
      var self = this;
      var engine = self.configureTypeaheadEngine();
      var property = self.get('property');
      engine.initialize();

      this.$().typeahead({
        hint: true,
        highlight: true,
        minLength: 1
      },{
        name: 'options',
        displayKey: function(model) {
          return model.get(property);
        },
        source: engine.ttAdapter()
      }).bind('typeahead:selected', $.proxy(function (obj, model) {
        //console.log("model %o", model);
        model.transitionTo('saved');
        self.set('selectedItem', model);
      }, this.$()));

      this.$('span.twitter-typeahead').addClass('geppii-searchinput');

    }.on('didInsertElement'),

    configureTypeaheadEngine: function() {

      var self = this;
      var session = self.get('session');
      var store = self.get('store');
      var property = self.get('property');
      var modelType = self.get('modelType');
      var type = store.modelFor(modelType);
      var serializer = store.serializerFor(type.typeKey);
      var id = self.get('modelID');
      var ignoredProperties = self.get('ignoredProperties');
      ignoredProperties = ignoredProperties ? ignoredProperties.split(',') : [];

      var engine = new Bloodhound({
        datumTokenizer: Bloodhound.tokenizers.obj.whitespace(property),
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        remote: {
          url: this.get('apiNamespace') + this.get('service') + '?unpaged=true&' + this.get('queryScope') + '=%QUERY',
          headers: {
            Authorization: 'Bearer ' + session.access_token
          },
          filter: function(response) {

            var models = [];
            var items = response[self.get('jsonRoot')];

            items.forEach(function(el) {
              var record = store.getById(modelType, el[id]);
              if(!record){
                var normalized = serializer.normalize(type, el);
                ignoredProperties.forEach(function(ignoredProp) {
                  delete normalized[ignoredProp];
                });
                record = store.createRecord(type, normalized);
              }
              record.transitionTo('saved');
              models.push(record);
            });
            return models;
          }
        }
      });
      return engine;
    }
  });
})();
