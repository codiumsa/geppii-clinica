Bodega.ControlInventarioRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.ControlInventariosIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('inventario', {page: 1, control: true});
  },
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.ControlInventarioEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('controlInventario');
  },

  renderTemplate: function() {
    this.render('controlInventarios.new', {
      controller: 'controlInventarioEdit'
    });
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('edit', true);

    var detalles = model.get('inventarioLote');

    detalles.then(function(response){
      controller.set('detalles', response);
    });

    model.get('deposito').then(function(response){
      controller.set('depositoSeleccionado', response);
    });
  }

});


Bodega.ControlInventarioDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('controlInventario');
  },

  renderTemplate: function() {
    this.render('controlInventarios.delete', {
      controller: 'controlInventarioDelete'
    });
  }
});

Bodega.ControlInventariosNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.createRecord('inventario');
  },
  
  setupController: function(controller, model) {
      controller.set('model', model);
      controller.set('edit', false);

      var detalles = model.get('inventarioLote');
      
      detalles.then(function(response){
        controller.set('detalles', response);
      });

      this.store.find('deposito').then(function(response){ 
          controller.set('depositos', response);
          var depositoDefault = response.objectAt(0);
          controller.set('depositoDefault', depositoDefault);
      });
    }
  
});