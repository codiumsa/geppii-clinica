Bodega.PagoDetallesIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('Detalle', {page: 1});
  },
  
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.PagoDetalleRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.PagoDetalleEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('Detalle');
  },

  renderTemplate: function() {
    this.render('pagoDetalles.new', {
      controller: 'pagoDetalleEdit'
    });
  }
});

Bodega.PagoDetalleDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('Detalle');
  },

  renderTemplate: function() {
    this.render('pagoDetalles.delete', {
      controller: 'pagoDetalleDelete'
    });
  }
});

Bodega.PagoDetallesNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    console.log("PagoDetallesNewRoute");
    return this.store.createRecord('Detalle');
  }
});