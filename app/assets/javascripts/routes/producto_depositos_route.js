Bodega.ProductoDepositosIndexRoute = Bodega.AuthenticatedRoute.extend({
	queryParams: {
    producto: {
      refreshModel: true
    }
  },

  model: function (params) {

    prueba = params['queryParams']
    
    params = {}
    params.page = 1
    params.producto_activo = true
		if (prueba != null)
    	params.by_producto_id = prueba['producto']

    return this.store.find('productoDeposito', params);
  },

  setupController: function (controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  },

});

Bodega.ProductoDepositoRoute = Bodega.AuthenticatedRoute.extend({});