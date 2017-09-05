Bodega.ControlInventariosIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable, 
  Bodega.mixins.Filterable, {
    resource:  'inventario'
});

Bodega.ControlInventariosBaseController = Ember.ObjectController.extend({
  needs: ['application'],
  
  formTitle: 'Nuevo Control Inventario',

  productoSeleccionado : null,

  habilitarEdicionDetalle : true,

  enters: 2,

  updateDetalles: function(){

    var self = this;
    var depositoSeleccionado = this.get('depositoDefault');
    var isEdit = this.get('edit');
    if(isEdit === undefined){
      /*Hack feo porque se le llama a esta función antes que al controller al hacer edit*/
      isEdit = true;
    }
    if(depositoSeleccionado && !isEdit){
      var productos = self.store.find('producto', {'by_deposito' : depositoSeleccionado.id});
      productos.then(function(response){
        var detalles = self.get('detalles');
        detalles.clear();
        response.forEach(function(producto){
          var detalle = self.store.createRecord('inventarioLote');
          detalle.set('producto', producto);
          detalle.set('existencia', 0);
          detalles.addRecord(detalle);
        });
      });
    }
  }.observes('depositoDefault'),

  actions: {

    contarEnters: function() {
      
      //console.log(this.get('enters'));
      var count = this.get('count');
      if (count === undefined) {
        count = 0;
        this.set('count', count);
      }

      count = count + 1;
      //console.log(count);
      if (count >= this.get('enters')) {
        this.set('count', 0);
        this.send('agregarDetalle');
      } else {
        this.set('count', count);
      }
    },

    
    cancel: function() {
      this.transitionToRoute('controlInventarios');
    },

    save: function() {
      var model = this.get('model');
      var self = this;
      var detalles = this.get('detalles');

      model.set('control', true);
      var depositoSeleccionado = this.get('depositoSeleccionado');
      
      if(depositoSeleccionado){
        model.set('deposito',depositoSeleccionado);
      }else{
        model.set('deposito',this.get('depositoDefault'));
      }
     
      Bodega.Utils.disableElement('button[type=submit]');

      if (model.get('isValid'))
      {
        model.save().then(function(response) {
          Bodega.Utils.enableElement('button[type=submit]');
          //guardar los detalles
          self.transitionToRoute('controlInventarios');
          if(self.get('edit')){
            Bodega.Notification.show('Éxito', 'El inventario se ha actualizado.');
          }else{
            Bodega.Notification.show('Éxito', 'El inventario se ha guardado.');
          }
          self.set('edit', undefined);
        }, function(response) {
          //error        
          Bodega.Utils.enableElement('button[type=submit]');
        });
      } else {
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },
  }
});
//********************************************************************************************
Bodega.ControlInventarioEditController = Bodega.ControlInventariosBaseController.extend({

  formTitle: 'Editar Control de Inventario',
  habilitarEdicionDetalle : false,

});

//********************************************************************************************
Bodega.ControlInventariosNewController = Bodega.ControlInventariosBaseController.extend({

  formTitle: 'Nuevo Control de Inventario',
  habilitarEdicionDetalle : true,
  
});
//********************************************************************************************
Bodega.ControlInventarioDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
			$('body').removeClass('modal-open');
      var self = this;
      var model = this.get('model');
      model.destroyRecord().then(function(response) {
        self.transitionToRoute('inventarios');
        Bodega.Notification.show('Éxito', 'El inventario se ha eliminado.');
      }, function(response){
        self.transitionToRoute('transferenciasDeposito');        
      });
      
    },

    cancel: function() {
			$('body').removeClass('modal-open');
      this.transitionToRoute('inventarios');
    }
  }
});