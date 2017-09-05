Bodega.LoteDepositosIndexRoute = Bodega.AuthenticatedRoute.extend({
	queryParams: {
    producto: {
      refreshModel: true
    }
  },

  model: function (params) {
		console.log(params);
    prueba = params.producto
    console.log(prueba);
    params = {}
    params.page = 1
    params.producto_activo = true
		if (prueba != null && prueba != 'undefined')
    	params.by_producto_id = prueba
    	return this.store.find('loteDeposito', params);
  },

  setupController: function (controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  },

});

Bodega.LoteDepositoRoute = Bodega.AuthenticatedRoute.extend({});
