Bodega.RecargosIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable, 
  Bodega.mixins.Filterable, {
    resource:  'recargo'
});

Bodega.RecargosBaseController = Ember.ObjectController.extend({
  needs: ['application'],
  
  formTitle: 'Nuevo Recargo',

  actions: {

  	save: function() {
      var model = this.get('model');
      var self = this;

      var tipoCreditoSeleccionado = self.get('tipoCreditoSeleccionado');
      if(tipoCreditoSeleccionado){
        model.set('tipoCredito', tipoCreditoSeleccionado);
      }else{
        model.set('tipoCredito', self.get('tipoCreditoDefault'));
      }

      var medioPagoSeleccionado = self.get('medioPagoSeleccionado');
      if(medioPagoSeleccionado){
        model.set('medioPago', medioPagoSeleccionado);
      }else{
        model.set('medioPago', self.get('medioPagoDefault'));
      }

      Bodega.Utils.disableElement('button[type=submit]');
      if (model.get('isValid'))
      {
        model.save().then(function(response) {
          Bodega.Utils.enableElement('button[type=submit]');
          self.transitionToRoute('recargos');
          if(self.get('edit')){
            Bodega.Notification.show('Éxito', 'El recargo se ha actualizado.');
          }else{
            Bodega.Notification.show('Éxito', 'El recargo se ha guardado.');
          }
        }, function(response) {
          //error        
          Bodega.Utils.enableElement('button[type=submit]');
        });
      } else {
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },

    cancel: function() {
      this.transitionToRoute('recargos');
    },
  }
});
//********************************************************************************************
Bodega.RecargoEditController = Bodega.RecargosBaseController.extend({

  formTitle: 'Editar Recargo',

});

//********************************************************************************************
Bodega.RecargosNewController = Bodega.RecargosBaseController.extend({

  formTitle: 'Nuevo Recargo',
  
});
//********************************************************************************************
Bodega.RecargoDeleteController = Bodega.RecargosBaseController.extend({
  actions: {
    deleteRecord: function() {
			$('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        Bodega.Notification.show('Éxito', 'El recargo se ha borrado.');
        self.transitionToRoute('recargos');
      }, function(response){
        var error = response.errors;
        Bodega.Notification.show('Error', 'No se pudo borrar el recargo. ' + error.base[0], Bodega.Notification.ERROR_MSG);
        self.transitionToRoute('recargos');        
      });
    },

    cancel: function() {
			$('body').removeClass('modal-open');
      this.transitionToRoute('recargos');
    }
  }
});