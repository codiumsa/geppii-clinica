Bodega.ReporteProductoRecargoIndexRoute = Bodega.AuthenticatedRoute.extend({
  setupController: function(controller, model) {


    tipoCreditoParams = {};
    tipoCreditoParams.by_activo = true;
    tipoCreditoParams.unpaged = true;

    this.store.find('tipoCredito').then(function(response) {
      controller.set('tiposCreditos', response);
      controller.set('tipoCreditoDefault', response.objectAt(0));
      controller.set('tipoCreditoSeleccionado', response.objectAt(0));
    });

    empresaParams = {};
    empresaParams.by_activo = true;
    empresaParams.unpaged = true;

    this.store.find('empresa', empresaParams).then(function(response){
      controller.set('empresas', response);
      controller.set('selectedEmpresa',response.content[0]);
    });


    medioPagoParams = {};
    medioPagoParams.by_activo = true;
    medioPagoParams.unpaged = true;
    this.store.find('medioPago', medioPagoParams).then(function(response){ 
      controller.set('mediosPagos', response);
      controller.set('medioPagoDefault', response.objectAt(0));
      controller.set('medioPagoSeleccionado', response.objectAt(0));
    });
   
  }
});

Bodega.ReporteProductoRecargo = Bodega.AuthenticatedRoute.extend({});