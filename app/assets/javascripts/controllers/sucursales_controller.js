Bodega.SucursalesIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable, 
  Bodega.mixins.Filterable, {
  resource:  'sucursal',
  staticFilters: {
   by_activo: true
  }
});

Bodega.SucursalesNewController = Ember.ObjectController.extend({

  formTitle: 'Nueva Sucursal',

  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      var errors = model.get('errors');
      
      var vendedor = this.get('vendedorSeleccionado');
      model.set('vendedor', vendedor);


      if (model.get('isValid')) {
        Bodega.Utils.disableElement('button[type=submit]');
        model.save().then(function(response) {
          //success
          if (model.get('crearDeposito')) {
            console.log("trayendo el deposito");
            this.store.find('deposito', {'by_id' : response.get('vendedor').get('id')}).then(function(response) {
            });
          }
          self.transitionToRoute('sucursales');
        }, function(response) {
          Bodega.Notification.show('Error', 'No se pudo crear la sucursal.', Bodega.Notification.ERROR_MSG);
          Bodega.Utils.enableElement('button[type=submit]');
        });
      } else {
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },

    cancel: function() {
      var model = this.get('model');
      model.deleteRecord();
      this.transitionToRoute('sucursales');
    }
  }
});

Bodega.SucursalEditController = Ember.ObjectController.extend({

  formTitle: 'Editar Sucursal',
  
  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      var errors = model.get('errors');

      var vendedor = this.get('vendedorSeleccionado');
      model.set('vendedor', vendedor);
      nuevaCaja = model.set('nuevaCaja',self.get('selectedCaja'));
      console.log("nuevacaja");
      console.log(nuevaCaja);
      if(model.get('deposito') && errors.has('deposito')) {
        // eliminamos los mensajes de error relacionados al producto padre ya que
        // el atributo dejó de ser undefined
        errors.remove('deposito');
      }
      
      if (model.get('isValid')) {
        Bodega.Utils.disableElement('button[type=submit]');
        model.save().then(function(response) {
          //success
          self.transitionToRoute('sucursales');
        }, function(response) {
           Bodega.Utils.enableElement('button[type=submit]');  
        });
      } else {
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },

    cancel: function() {
      this.transitionToRoute('sucursales');
    }
  }
});

Bodega.SucursalDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
			$('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        self.transitionToRoute('sucursales');
      });
    },

    cancel: function() {
			$('body').removeClass('modal-open');
      this.transitionToRoute('sucursales');
    }
  }
});