Bodega.ReporteVentasMedioPagoIndexRoute = Bodega.AuthenticatedRoute.extend({
  setupController: function(controller, model) {
  
  empresaParams = {};
  empresaParams.by_activo = true;
  empresaParams.unpaged = true;
  
  this.store.find('empresa', empresaParams).then(function(response){
      controller.set('empresas', response);
      if(response.content.length > 1){
        controller.set('multiEmpresa',true);
      }else{
        controller.set('multiEmpresa',false);
      }
      controller.set('selectedEmpresa',response.content[0]);
    });

  // this.store.find('medioPago').then(function(response){ 
  //   controller.set('mediosPagos', response);
  //   controller.set('medioPagoDefault', response.objectAt(0));
  //   controller.set('medioPagoSeleccionado', response.objectAt(0));
  // });
   
        var date = new Date(), y = date.getFullYear(), m = date.getMonth();
      var firstDay = new Date(y, m, 1);
      var lastDay = new Date(y, m + 1, 1);

    controller.set('fecha_inicio_despues',firstDay);
    controller.set('fecha_inicio_antes',lastDay);
   
  }
});

Bodega.ReporteProductoRecargo = Bodega.AuthenticatedRoute.extend({});