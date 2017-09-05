Bodega.MedioPagosIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('medioPago', {page: 1, by_activo: true});
  },
  
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  },

   
});

Bodega.MedioPagoRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.MedioPagosNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    var record = this.store.createRecord('medioPago');
    console.log(record);
    return record;
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.MedioPagoEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('medioPago');
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
   
  },

  renderTemplate: function() {
    this.render('medioPagos.new', {
      controller: 'medioPagoEdit'
    });
  }
});

Bodega.MedioPagoDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('medioPago');
  },

  renderTemplate: function() {
    this.render('medioPagos.delete', {
      controller: 'medioPagoDelete'
    });
  }
});


