Bodega.ReporteProductoLoteIndexRoute = Bodega.AuthenticatedRoute.extend({
  setupController: function(controller, model) {

	this.store.find('lote').then(function(response){
      controller.set('lotes', response);
    });
      
       controller.set('descripcionSW', null);
      controller.set('productoSeleccionadoSW', null);

	categoriaParams = {};
    categoriaParams.by_activo = true;
    categoriaParams.unpaged = true;

   	this.store.find('categoria', categoriaParams).then(function(response){
      controller.set('categorias', response);
    });

	controller.set('incluyeCero', false);
   
  }
});

Bodega.ReporteProductoLote = Bodega.AuthenticatedRoute.extend({});