Bodega.MonedasIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable, 
  Bodega.mixins.Filterable, {
    resource:  'moneda'
});

Bodega.MonedasBaseController = Ember.ObjectController.extend({
  needs: ['application'],
  
  formTitle: 'Nueva Moneda',

  actions: {

  	save: function() {
      var model = this.get('model');
      var self = this;

      Bodega.Utils.disableElement('button[type=submit]');
      if (model.get('isValid'))
      {
        model.save().then(function(response) {
          Bodega.Utils.enableElement('button[type=submit]');
          self.transitionToRoute('monedas');
          if(self.get('edit')){
            Bodega.Notification.show('Éxito', 'La moneda se ha actualizado.');
          }else{
            Bodega.Notification.show('Éxito', 'La moneda se ha guardado.');
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
      this.transitionToRoute('monedas');
    },
  }
});
//********************************************************************************************
Bodega.MonedaEditController = Bodega.MonedasBaseController.extend({

  formTitle: 'Editar Moneda',

});

//********************************************************************************************
Bodega.MonedasNewController = Bodega.MonedasBaseController.extend({

  formTitle: 'Nueva Moneda',
  
});
//********************************************************************************************
Bodega.MonedaDeleteController = Bodega.MonedasBaseController.extend({
  actions: {
    deleteRecord: function() {
    	console.log('DELETE RECORD');
			$('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        Bodega.Notification.show('Éxito', 'La moneda se ha anulado.');
        self.transitionToRoute('monedas');
      }, function(response){
        var error = response.errors;
        Bodega.Notification.show('Error', 'No se pudo anular la moneda. ' + error.base[0], Bodega.Notification.ERROR_MSG);
        self.transitionToRoute('monedas');        
      });
    },

    cancel: function() {
    	console.log('CANCEL DELETE');
			$('body').removeClass('modal-open');
      this.transitionToRoute('monedas');
    }
  }
});