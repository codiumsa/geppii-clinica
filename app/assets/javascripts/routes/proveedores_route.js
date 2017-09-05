Bodega.ProveedoresIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('proveedor', {page: 1, ignorar_proveedor_default: true});
  },
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.ProveedorRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.ProveedorEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('proveedor');
  },

  renderTemplate: function() {
    this.render('proveedores.new', {
      controller: 'proveedorEdit'
    });
  }
});

Bodega.ProveedorDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('proveedor');
  },

  renderTemplate: function() {
    this.render('proveedores.delete', {
      controller: 'proveedorDelete'
    });
  }
});


Bodega.ProveedoresNewRoute = Bodega.AuthenticatedRoute.extend({
 model: function() {
   return this.store.createRecord('proveedor');
 }
});