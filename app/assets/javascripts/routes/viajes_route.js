Bodega.ViajesIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('viaje', {page: 1});
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.ViajeRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.ViajeEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('viaje');
  },

  renderTemplate: function() {
    this.render('viajes.new', {
      controller: 'viajeEdit'
    });
  },
  setupController: function(controller, model) {
    controller.set('model', model);

    var viajes = model.get('viajeColaboradores');
    console.log('viajes', viajes);
    viajes.then(function(response){
      console.log("Seteando viajes: ", response);
      controller.set('colaboradores', response);
    });

  }
});

Bodega.ViajeDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('viaje');
  },

  renderTemplate: function() {
    this.render('viajes.delete', {
      controller: 'viajeDelete'
    });
  }
});

Bodega.ViajesNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    var record = this.store.createRecord('viaje');
    return record;
  },
  setupController: function(controller, model) {
    controller.set('model', model);

    var viajes = model.get('viajeColaboradores');
    console.log('viajes', viajes);
    viajes.then(function(response){
      console.log("Seteando viajes: ", response);
      controller.set('colaboradores', response);
    });

  }
});
