Bodega.MedioPagosIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable, 
  Bodega.mixins.Filterable, {
  resource:  'medioPago',
  perPage:  15,
 // staticFilters: {
  //  ignorar_cliente_default: true
  //}
});


Bodega.MedioPagosNewController = Ember.ObjectController.extend({
  formTitle: 'Nuevo Medio de Pago',

  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;

      Bodega.Utils.disableElement('.btn');
      //console.log("model cat cliente %o", model);
      model.save().then(function(response) {
        self.transitionToRoute('medioPagos').then(function () {
            Bodega.Notification.show('Éxito', 'Medio de pago registrado');
            Bodega.Utils.enableElement('.btn');
          }); 
        
      }, function(response) {
        console.log(response);
         Bodega.Notification.show('Error', 'Ha ocurrido un error al guardar el medio de pago', 
                                  Bodega.Notification.ERROR_MSG );
         // model.rollback();
        //  model.transitionTo('uncommitted');
          Bodega.Utils.enableElement('.btn');
          Bodega.Utils.enableElement('button[type=submit]');
      });
    
    },

    cancel: function() {
      var model = this.get('model');
      this.transitionToRoute('medioPagos');
    }
  }
});


Bodega.MedioPagoEditController = Ember.ObjectController.extend({
  formTitle: 'Editar Medio de Pago',
  
  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      Bodega.Utils.disableElement('.btn');
      model.save().then(function(response) {
        self.transitionToRoute('medioPagos').then(function () {
            Bodega.Notification.show('Éxito', 'Medio de pago actualizado');
            Bodega.Utils.enableElement('.btn');
          }); 
        
      }, function(response) {
          Bodega.Notification.show('Error', 'Ha ocurrido un error al editar el medio de pago', 
                                  Bodega.Notification.ERROR_MSG );
          //model.rollback();
          model.transitionTo('uncommitted');
          Bodega.Utils.enableElement('.btn');
      });
    
    },

    cancel: function() {
      var model = this.get('model');
      this.transitionToRoute('medioPagos');
    }
  }
});

Bodega.MedioPagoDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
			$('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        self.transitionToRoute('medioPagos').then(function () {
          Bodega.Notification.show('Exito', 'El medio de pago se ha eliminado.');
          Bodega.Utils.enableElement('button[type=submit]');
        });
      }, function(response) {

        Bodega.Notification.show('Error', 'No se pudo borrar el medio de pago.', Bodega.Notification.ERROR_MSG);
        Bodega.Utils.enableElement('button[type=submit]');
        //model.rollback();
        model.transitionTo('uncommitted');
      });
    },

    cancel: function() {
			$('body').removeClass('modal-open');
      this.transitionToRoute('medioPagos');
    }
  }
});