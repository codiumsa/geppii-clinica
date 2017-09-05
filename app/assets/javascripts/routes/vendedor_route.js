Bodega.VendedoresIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    queryParams: ['vendedor'],
    params = {}
    params.by_activo = true
    params.page = 1

    return this.store.find('vendedor', params);
  },
  
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.VendedorRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.VendedorEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('vendedor');
  },

  renderTemplate: function() {
    this.render('vendedores.new', {
      controller: 'vendedorEdit'
    });
  }
});

Bodega.VendedorDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('vendedor');
  },

  renderTemplate: function() {
    this.render('vendedores.delete', {
      controller: 'vendedorDelete'
    });
  }
});

Bodega.VendedoresNewRoute = Bodega.AuthenticatedRoute.extend({

  model: function() {
    return this.store.createRecord('vendedor');
  }
});