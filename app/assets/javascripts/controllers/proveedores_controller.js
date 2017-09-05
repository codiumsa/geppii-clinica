Bodega.ProveedoresIndexController = Ember.ArrayController.extend(Bodega.mixins.Pageable, 
  Bodega.mixins.Filterable,  {
  resource:  'proveedor',
  staticFilters: {
    ignorar_proveedor_default: true
  }
});

Bodega.ProveedoresNewController = Ember.ObjectController.extend({
  
  formTitle: 'Nuevo Proveedor',

  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      model.save().then(function(response) {
        // success
        self.transitionToRoute('proveedores').then(function () {
          Bodega.Notification.show('Éxito', 'El proveedor se ha guardado.');
          Bodega.Utils.enableElement('button[type=submit]');
        });
      }, function(response){
        // error
        Bodega.Notification.show('Error', 'No se pudo guardar el proveedor', 'error');
        Bodega.Utils.enableElement('button[type=submit]');
        model.transitionTo('uncommitted');
      });
    },

    cancel: function() {
      var model = this.get('model');
      this.transitionToRoute('proveedores');
    }
  }
});

Bodega.ProveedorEditController = Ember.ObjectController.extend({

  formTitle: 'Editar Proveedor',
  
  actions: {
    save: function() {
      var model = this.get('model');    
      var self = this;
      model.save().then(function(response) {
        //success
        self.transitionToRoute('proveedores').then(function () {
          Bodega.Notification.show('Éxito', 'El proveedor se ha actualizado.');
          Bodega.Utils.enableElement('button[type=submit]');
        });
      }, function(response) {
        //error
        Bodega.Notification.show('Error', 'No se pudo actualizar el proveedor', 'error');
        Bodega.Utils.enableElement('button[type=submit]');
        model.transitionTo('uncommitted');
      });
    },

    cancel: function() {
      this.transitionToRoute('proveedores');
    }
  }
});

Bodega.ProveedorDeleteController = Ember.ObjectController.extend({
  actions: {
    deleteRecord: function() {
			$('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        Bodega.Notification.show('Éxito', 'El proveedor se ha eliminado.');
        self.transitionToRoute('proveedores');
      }, function(response){
        var error = response.errors;
        model.transitionTo('uncommitted');
        Bodega.Notification.show('Error', 'No se pudo borrar el proveedor. ' + error.base[0], Bodega.Notification.ERROR_MSG);
        self.transitionToRoute('proveedores');        
      });
    },

    cancel: function() {
			$('body').removeClass('modal-open');
      this.transitionToRoute('proveedores');
    }
  }
});