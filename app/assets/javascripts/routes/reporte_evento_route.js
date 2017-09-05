Bodega.ReporteEventoIndexRoute = Bodega.AuthenticatedRoute.extend({
  setupController: function(controller, model) {   
	this.store.find('usuario').then(function(response){
      controller.set('usuarios', response);
    });
  }
});

Bodega.ReporteEvento = Bodega.AuthenticatedRoute.extend({});