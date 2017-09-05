Bodega.ReporteMovimientoCajaIndexRoute = Bodega.AuthenticatedRoute.extend({
  setupController: function(controller, model) {

	this.store.find('caja', {'unpaged':true}).then(function(response){
      controller.set('cajas', response);
      controller.set('cajaDefault', response.objectAt(0));
    });
   
  }
});

Bodega.ReporteMovimientoCaja = Bodega.AuthenticatedRoute.extend({});