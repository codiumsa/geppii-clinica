Bodega.ReporteDescuentoIndexRoute = Bodega.AuthenticatedRoute.extend({
  setupController: function(controller, model) {
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
      } else {
        controller.set('soportaMultimoneda', false);
      }
    });

    this.store.find('moneda', {'by_activo' : true}).then(function(response){ 
          controller.set('monedas', response);
          controller.set('monedaSeleccionada', response.objectAt(0));
    });

    this.store.find('usuario').then(function(response){
      controller.set('usuarios', response);
    });
  }
});

Bodega.ReporteDescuento = Bodega.AuthenticatedRoute.extend({});