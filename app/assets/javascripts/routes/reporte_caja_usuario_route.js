Bodega.ReporteCajaUsuarioIndexRoute = Bodega.AuthenticatedRoute.extend({
  setupController: function(controller, model) {   
	this.store.find('usuario').then(function(response){
      controller.set('usuarios', response);
      controller.set('selectedUsuario', response.objectAt(0));
    });
  }
});

Bodega.ReporteCajaUsuario = Bodega.AuthenticatedRoute.extend({});