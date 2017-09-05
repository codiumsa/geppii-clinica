Bodega.MovimientosIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable, 
  Bodega.mixins.Filterable, {
  resource:  'movimiento',
  perPage:  10
});

Bodega.MovimientoDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
      $('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        //console.log(model.get('id'));
        //mov = self.get('store').getById('movimiento', model.get('id'));
        //console.log(mov);
        //mov.reload().then(function(p) {
          self.get('store').unloadAll('operacion');
          self.transitionToRoute('movimientos').then(function () {
            Bodega.Notification.show('Exito', 'La operación se ha reversado.');
            Bodega.Utils.enableElement('button[type=submit]');
          });
        //});
      }, function(response) {
        Bodega.Notification.show('Error', 'No se pudo reversar la operacion.', Bodega.Notification.ERROR_MSG);
        Bodega.Utils.enableElement('button[type=submit]');
      });
    },

    cancel: function() {
      $('body').removeClass('modal-open');
      this.transitionToRoute('movimientos');
    }
  }
});