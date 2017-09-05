Bodega.VendedoresIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable, 
  Bodega.mixins.Filterable, {
  resource:  'vendedor',
  perPage:  15
});

Bodega.VendedoresNewController = Ember.ObjectController.extend({

  formTitle: 'Nuevo Vendedor',

  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      Bodega.Utils.disableElement('button[type=submit]');

      if(model.get('isValid')) {
        model.save().then(function(response) {
          // success
          self.transitionToRoute('vendedores').then(function () {
            Bodega.Notification.show('Exito', 'El vendedor se ha guardado.');
            Bodega.Utils.enableElement('button[type=submit]');
          });
        }, function(response){
          // error
          Bodega.Utils.enableElement('button[type=submit]');
        });
      }else{
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },

    cancel: function() {
      var model = this.get('model');
      this.transitionToRoute('vendedores');
    }
  }
});

Bodega.VendedorEditController = Ember.ObjectController.extend({

  formTitle: 'Editar Vendedor',
  
  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      Bodega.Utils.disableElement('button[type=submit]');
      
      if(model.get('isValid')) {
        model.save().then(function(response) {
          //success
          self.transitionToRoute('vendedores').then(function () {
            Bodega.Notification.show('Exito', 'El vendedor se ha actualizado.');
            Bodega.Utils.enableElement('button[type=submit]');
          });
        }, function(response) {
          //error
          Bodega.Notification.show('Error', "Error al guardar el Vendedor, verifique la existencia de la sucursal", Bodega.Notification.ERROR_MSG );                
          Bodega.Utils.enableElement('button[type=submit]');
        });
      }else{
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },

    cancel: function() {
      this.transitionToRoute('vendedores');
    }
  }
});

Bodega.VendedorDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
			$('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      model.destroyRecord().then(function() {
        Bodega.Notification.show('Exito', 'El vendedor se ha eliminado.');
        self.transitionToRoute('vendedores');
      },function(response){
        var error = response.errors;
        model.transitionTo('uncommitted');
        Bodega.Notification.show('Error', 'No se pudo borrar el vendedor. ' + error.base[0], Bodega.Notification.ERROR_MSG);
        self.transitionToRoute('vendedores');        
      });
    },

    cancel: function() {
			$('body').removeClass('modal-open');
      this.transitionToRoute('vendedores');
    }
  }
});