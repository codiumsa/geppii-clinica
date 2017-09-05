Bodega.ReporteMovimientoVentaIndexRoute = Bodega.AuthenticatedRoute.extend({
  setupController: function(controller, model) {
    //depositoParams = {}
    // depositoParams.by_activo = true
    // this.store.find('deposito', depositoParams).then(function(response){
    //   controller.set('depositos', response);
    // });
	
  	sucursalParams = {};
  	sucursalParams.by_activo = true;

  	this.store.find('sucursal', sucursalParams).then(function(response){
        controller.set('sucursales', response);
        controller.set('selectedSucursal', response.objectAt(0)); 
      });

    var parametroMultimoneda = this.store.find('parametrosEmpresa', {'by_soporta_multimoneda': true, 'unpaged' : true});
    parametroMultimoneda.then(function() {
      if(parametroMultimoneda.objectAt(0)){
          controller.set('soportaMultimoneda', true);
      }
      else{
        controller.set('soportaMultimoneda', false);
      }
    });

    this.store.find('moneda', {'by_activo' : true}).then(function(response){ 
          controller.set('monedas', response);
          controller.set('monedaSeleccionada', response.objectAt(0));
    });
  }
});

Bodega.ReporteMovimientoVenta = Bodega.AuthenticatedRoute.extend({});