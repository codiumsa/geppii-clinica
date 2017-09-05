Bodega.VentaDetallesIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('ventaDetalle', {page: 1});
  },
  
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.VentaDetalleRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.VentaDetalleEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('ventaDetalle');
  },

  renderTemplate: function() {
    this.render('ventaDetalles.new', {
      controller: 'ventaDetalleEdit'
    });
  }
});

Bodega.VentaDetalleDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('ventaDetalle');
  },

  renderTemplate: function() {
    this.render('ventaDetalles.delete', {
      controller: 'ventaDetalleDelete'
    });
  }
});

Bodega.VentaDetallesNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    console.log("VentaDetallesNewRoute");
    return this.store.createRecord('ventaDetalle');
  }
});