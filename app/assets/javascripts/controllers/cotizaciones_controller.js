Bodega.CotizacionesIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable, 
  Bodega.mixins.Filterable, {
    resource:  'cotizacion'
});


Bodega.CotizacionesNewController = Ember.ObjectController.extend({

  formTitle: 'Nueva Cotización',

  actions: {

    save: function() {
      var model = this.get('model');
      var self = this;

      var monedaSeleccionada = this.get('monedaSeleccionada');
      if(monedaSeleccionada){
        model.set('moneda', monedaSeleccionada);
      }else{
        model.set('moneda', this.get('monedaDefault'));
      }

      var monedaBaseSeleccionada = this.get('monedaBaseSeleccionada');
      if(monedaBaseSeleccionada){
        model.set('monedaBase', monedaBaseSeleccionada);
      }else{
        model.set('monedaBase', this.get('monedaDefault'));
      }

      Bodega.Utils.disableElement('button[type=submit]');
      if (model.get('isValid'))
      {
        model.save().then(function(response) {
          Bodega.Utils.enableElement('button[type=submit]');
          self.transitionToRoute('cotizaciones');
          Bodega.Notification.show('Éxito', 'La cotización se ha guardado.');
        }, function(response) {
          //error        
          Bodega.Utils.enableElement('button[type=submit]');
        });
      } else {
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },

    cancel: function() {
      this.transitionToRoute('cotizaciones');
    },
  }
});