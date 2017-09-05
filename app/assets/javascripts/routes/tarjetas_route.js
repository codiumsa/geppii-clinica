Bodega.TarjetasIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('tarjeta', {page: 1, by_activo: true});
  },
  
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  },

   
});

Bodega.TarjetaRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.TarjetasNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    var record = this.store.createRecord('tarjeta');
    console.log(record);
    return record;
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
    this.store.find('medioPago').then(function(response){ 
        controller.set('medioPagos', response);
        controller.set('medioDefault', response.objectAt(0));
    }); 
  }
});

Bodega.TarjetaEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('tarjeta');
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
    this.store.find('medioPago').then(function(response){ 
        controller.set('medioPagos', response);
        controller.set('medioDefault', controller.get('model').get('medioPago'));
        controller.set('medioSeleccionado', controller.get('model').get('medioPago'));
        console.log(controller.get('medioSeleccionado'));

    });    
  },

  renderTemplate: function() {
    this.render('tarjetas.new', {
      controller: 'tarjetaEdit'
    });
  }
});

Bodega.TarjetaDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('tarjeta');
  },

  renderTemplate: function() {
    this.render('tarjetas.delete', {
      controller: 'tarjetaDelete'
    });
  }
});


