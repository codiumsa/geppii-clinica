Bodega.MovimientosIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('movimiento', {page: 1});
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
    controller.set('muestraSaldo', this.get('session').get('permisos').indexOf('FE_show_cajas_saldo') > 0);


  }

});

Bodega.MovimientoDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('movimiento');
  },

  renderTemplate: function() {
    this.render('movimientos.delete', {
      controller: 'movimientoDelete'
    });
  },
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('store', this.store);
  }
});