Bodega.PromocionProductosIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('PromocionProducto', {page: 1});
  },
  
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.PromocionProductoRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.PromocionProductoEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('PromocionProducto');
  },

  renderTemplate: function() {
    this.render('PromocionProductos.new', {
      controller: 'PromocionProductoEdit'
    });
  }
});

Bodega.PromocionProductoDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('PromocionProducto');
  },

  renderTemplate: function() {
    this.render('PromocionProductos.delete', {
      controller: 'PromocionProductoDelete'
    });
  }
});

Bodega.PromocionProductosNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.createRecord('PromocionProducto');
  }
});