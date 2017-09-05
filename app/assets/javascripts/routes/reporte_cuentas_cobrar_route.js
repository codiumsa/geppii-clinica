
Bodega.ReporteCuentasCobrarIndexRoute = Bodega.AuthenticatedRoute.extend({
  setupController: function(controller, model) {
    sucursalParams = {};
    sucursalParams.by_activo = true;
    sucursalParams.unpaged = true;

    empresaParams = {};
    empresaParams.by_activo = true;
    empresaParams.unpaged = true;
    this.store.find('sucursal', sucursalParams).then(function(response){
      controller.set('sucursales', response);
    });
		this.store.find('empresa', empresaParams).then(function(response){
      controller.set('empresas', response);
    });
   
  }
});

Bodega.ReporteCuentasCobrar = Bodega.AuthenticatedRoute.extend({});