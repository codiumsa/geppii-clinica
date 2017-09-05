Bodega.TarjetasIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable, 
  Bodega.mixins.Filterable, {
  resource:  'tarjeta',
  perPage:  15,
 // staticFilters: {
  //  ignorar_cliente_default: true
  //}
});


Bodega.TarjetasNewController = Ember.ObjectController.extend({
  formTitle: 'Nueva Tarjeta',

  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      var medioSeleccionado = this.get('medioSeleccionado');
      if(medioSeleccionado){
        model.set('medioPago', medioSeleccionado);
      }else{
        model.set('medioPago', this.get('medioDefault'));
      }

      Bodega.Utils.disableElement('.btn');
      //console.log("model cat cliente %o", model);
      model.save().then(function(response) {
        self.transitionToRoute('tarjetas').then(function () {
            Bodega.Notification.show('Éxito', 'Tarjeta registrada');
            Bodega.Utils.enableElement('.btn');
          }); 
        
      }, function(response) {
        console.log(response);
         Bodega.Notification.show('Error', 'Ha ocurrido un error al guardar la tarjeta cliente', 
                                  Bodega.Notification.ERROR_MSG );
         // model.rollback();
        //  model.transitionTo('uncommitted');
          Bodega.Utils.enableElement('.btn');
          Bodega.Utils.enableElement('button[type=submit]');
      });
    
    },

    cancel: function() {
      var model = this.get('model');
      this.transitionToRoute('tarjetas');
    }
  }
});


Bodega.TarjetaEditController = Ember.ObjectController.extend({
  formTitle: 'Editar Tarjeta',
  
  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      var medioSeleccionado = this.get('medioSeleccionado');
      var medioDefault = this.get('medioDefault');
      console.log('SELECCIONADO: ');
      console.log(medioSeleccionado);
      console.log('DEFAULT: ');
      console.log(medioDefault);
      
      if(medioSeleccionado){
        model.set('medioPago', medioSeleccionado);
      }else{
        model.set('medioPago', medioDefault);
      }
      Bodega.Utils.disableElement('.btn');
      model.save().then(function(response) {
        self.transitionToRoute('tarjetas').then(function () {
            Bodega.Notification.show('Éxito', 'Tarjeta actualizada');
            Bodega.Utils.enableElement('.btn');
          }); 
        
      }, function(response) {
          Bodega.Notification.show('Error', 'Ha ocurrido un error al editar la tarjeta cliente', 
                                  Bodega.Notification.ERROR_MSG );
          //model.rollback();
          model.transitionTo('uncommitted');
          Bodega.Utils.enableElement('.btn');
      });
    
    },

    cancel: function() {
      var model = this.get('model');
      this.transitionToRoute('tarjetas');
    }
  }
});

Bodega.TarjetaDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
			$('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        self.transitionToRoute('tarjetas').then(function () {
          Bodega.Notification.show('Exito', 'La tarjeta se ha eliminado.');
          Bodega.Utils.enableElement('button[type=submit]');
        });
      }, function(response) {

        Bodega.Notification.show('Error', 'No se pudo borrar la tarjeta.', Bodega.Notification.ERROR_MSG);
        Bodega.Utils.enableElement('button[type=submit]');
        //model.rollback();
        model.transitionTo('uncommitted');
      });
    },

    cancel: function() {
			$('body').removeClass('modal-open');
      this.transitionToRoute('tarjetas');
    }
  }
});