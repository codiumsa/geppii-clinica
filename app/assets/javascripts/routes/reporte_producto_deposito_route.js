Bodega.ReporteProductoDepositoIndexRoute = Bodega.AuthenticatedRoute.extend({
  setupController: function(controller, model) {

	depositoParams = {};
    depositoParams.by_activo = true;
    depositoParams.unpaged = true;

	this.store.find('deposito', depositoParams).then(function(response){
      controller.set('depositos', response);
    });

	categoriaParams = {};
    categoriaParams.by_activo = true;
    categoriaParams.unpaged = true;

   	this.store.find('categoria', categoriaParams).then(function(response){
      controller.set('categorias', response);
    });

	controller.set('incluyeCero', false);
   
  }
});

Bodega.ReporteProductoDeposito = Bodega.AuthenticatedRoute.extend({});