 
Bodega.InventarioRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.InventariosIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('inventario', {page: 1, control: false});
  },
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.InventarioEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('inventario');
  },

  renderTemplate: function() {
    this.render('inventarios.new', {
      controller: 'inventarioEdit'
    });
  },

  setupController: function(controller, model) {
      controller.set('model', model);
      controller.set('edit', true);
      controller.set('habilitarEdicionDetalle', (true && (model.get('procesado')==false)));

      var detalles = model.get('inventarioLote');

      detalles.then(function(response){
        controller.set('detalles', response);
      });
      controller.set('detNuevo', this.store.createRecord('inventarioLote')); 

      this.store.find('deposito').then(function(response){ 
        controller.set('depositos', response);
        controller.set('depositoDefault', response.objectAt(0));
      });

      model.get('deposito').then(function(response){
        controller.set('depositoSeleccionado', response);
      });
    }

});


Bodega.InventarioDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('inventario');
  },

  renderTemplate: function() {
    this.render('inventarios.delete', {
      controller: 'inventarioDelete'
    });
  }
});

Bodega.InventariosNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.createRecord('inventario');
  },
  
  setupController: function(controller, model) {
      controller.set('model', model);
      controller.set('habilitarEdicionDetalle', true);
      var detalles = model.get('inventarioLote');
      
      detalles.then(function(response){
        controller.set('detalles', response);
      });

      controller.set('detNuevo', this.store.createRecord('inventarioLote')); 
      this.store.find('deposito').then(function(response){ 
        controller.set('depositos', response);
        controller.set('depositoDefault', response.objectAt(0));
      });  
    }

  
});