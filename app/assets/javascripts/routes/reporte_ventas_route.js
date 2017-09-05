Bodega.ReporteVentasIndexRoute = Bodega.AuthenticatedRoute.extend({
  setupController: function(controller, model) {
    sucursalParams = {};
    sucursalParams.by_activo = true;
    sucursalParams.unpaged = true;
		empresaParams = {};
    empresaParams.by_activo = true;
    empresaParams.unpaged = true;

    tipoCreditoParams = {};
    tipoCreditoParams.by_activo = true;
    tipoCreditoParams.unpaged = true;

    this.store.find('sucursal', sucursalParams).then(function(response){
      controller.set('sucursales', response);
    });
		this.store.find('empresa', empresaParams).then(function(response){
      controller.set('empresas', response);
    });
    this.store.find('tipoCredito', tipoCreditoParams).then(function(response){
      controller.set('tipoCreditos', response);
    });
    this.store.find('tipoSalida',{'unpaged':true}).then(function(response){
      controller.set('tiposSalida', response);
    });
    tipoPago = ['Contado', 'Crédito'];
    controller.set("tipoPago", tipoPago);

      var date = new Date(), y = date.getFullYear(), m = date.getMonth();
      var firstDay = new Date(y, m, 1);
      var lastDay = new Date(y, m + 1, 1);

    controller.set('fecha_despues',firstDay);
    controller.set('fecha_antes',lastDay);

  }
});

Bodega.ReporteCompras = Bodega.AuthenticatedRoute.extend({});
