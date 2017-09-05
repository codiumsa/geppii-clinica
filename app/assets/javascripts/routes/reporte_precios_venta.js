Bodega.ReportePreciosVentaIndexRoute = Bodega.AuthenticatedRoute.extend({
  setupController: function(controller, model) {
    
    empresaParams = {};
  	empresaParams.by_activo = true;
	empresaParams.unpaged = true;
    this.store.find('empresa', empresaParams).then(function(response){
      controller.set('empresas', response);
      controller.set('selectedEmpresa',response.content[0]);
    });
   
  }
});

Bodega.ReportePreciosVenta = Bodega.AuthenticatedRoute.extend({});