Bodega.ReporteComprasIndexRoute = Bodega.AuthenticatedRoute.extend({
  setupController: function(controller, model) {
    
    proveedorParams = {};
    proveedorParams.by_activo = true;
    proveedorParams.unpaged = true;
    this.store.find('proveedor', proveedorParams).then(function(response){
      controller.set('proveedores', response);
    });
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

    tipoCreditoParams = {};
    tipoCreditoParams.by_activo = true;
    tipoCreditoParams.unpaged = true;

    this.store.find('tipoCredito', tipoCreditoParams).then(function(response){
      controller.set('tipoCreditos', response);
    });

    depositoParams = {};
    depositoParams.by_activo = true;
    depositoParams.unpaged = true;
		this.store.find('deposito', depositoParams).then(function(response){
      controller.set('depositos', response);
    });
    tipoPago = ['Contado', 'Crédito'];
    controller.set("tipoPago", tipoPago);
   
  }
});

Bodega.ReporteCompras = Bodega.AuthenticatedRoute.extend({});