Bodega.ProduccionesIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('produccion', {page: 1});
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.ProduccionRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.ProduccionEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('produccion');
  },

  renderTemplate: function() {
    this.render('producciones.new', {
      controller: 'produccionEdit'
    });
  }
});

Bodega.ProduccionDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('produccion');
  },

  renderTemplate: function() {
    this.render('producciones.delete', {
      controller: 'produccionDelete'
    });
  }
});

Bodega.ProduccionesNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    var record = this.store.createRecord('produccion');
    return record;
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    depositoParams = {};
    depositoParams.by_activo = true;
    depositoParams.unpaged = true;
    controller.set('detalles', null);

    var detalles = model.get('produccionDetalles');
    console.log('Detalles: ', detalles);
    detalles.then(function(response){
      console.log("Seteando Detalles: ", response);
      controller.set('produccionDetallesController', response);

    });

    this.store.find('deposito', depositoParams).then(function(response){
      controller.set('depositos', response);
      controller.set('depositoSeleccionado', response.objectAt(0));
    });
  }
});
