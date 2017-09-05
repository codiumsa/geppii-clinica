Bodega.ReporteGananciasIndexRoute = Bodega.AuthenticatedRoute.extend({
  setupController: function(controller, model) {
    sucursalParams = {};
    sucursalParams.by_activo = true;
    sucursalParams.unpaged = true;

    this.store.find('sucursal', sucursalParams).then(function(response){
      controller.set('sucursales', response);
    });
   
  }
});

Bodega.ReporteGanancias = Bodega.AuthenticatedRoute.extend({});