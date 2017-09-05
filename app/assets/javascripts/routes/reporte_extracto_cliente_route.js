Bodega.ReporteExtractoClienteIndexRoute = Bodega.AuthenticatedRoute.extend({
  setupController: function(controller, model) {
    console.log("Reporte Extracto Cliente: iniciando controlador");
    sucursalParams = {};
    sucursalParams.by_activo = true;
    sucursalParams.unpaged = true;

    monedaParams = {};
    monedaParams.by_activo = true;

    parametroParams = {};
    parametroParams.unpaged = true;

    var sucursal = null;
		this.store.find('sucursal', sucursalParams).then(function(response){
      controller.set('sucursales', response);
      controller.set('selectedSucusal', response.objectAt(0));
      parametroParams.by_sucursal = response.objectAt(0).get('id');
      console.log(parametroParams);   
    });

    this.store.find('parametrosEmpresa', parametroParams).then(function(response){
      console.log(response);
      if (response.get('soportaMultimoneda')){
        controller.set('soportaMultimoneda', true);
      }else{
        controller.set('soportaMultimoneda', false);
      }
    });
    
    this.store.find('moneda', monedaParams).then(function(response){
      controller.set('monedas', response);
      controller.set('selectedMoneda', response.objectAt(0));
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
  }
});

Bodega.ReporteExtractoCliente = Bodega.AuthenticatedRoute.extend({});