Bodega.TipoProductosIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('tipoProducto', {page: 1});
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.TipoProductoRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.TipoProductoEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('tipoProducto');
  },

  renderTemplate: function() {
    this.render('tipoProductos.new', {
      controller: 'tipoProductoEdit'
    });
  }
});

Bodega.TipoProductoDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('tipoProducto');
  },

  renderTemplate: function() {
    this.render('tipoProductos.delete', {
      controller: 'tipoProductoDelete'
    });
  }
});

Bodega.TipoProductosNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    var record = this.store.createRecord('tipoProducto');
    return record;
  },

  setupController: function(controller, model) {
    controller.set('model', model);
  }
});
