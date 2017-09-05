Bodega.ReporteInventariosIndexRoute = Bodega.AuthenticatedRoute.extend({
  setupController: function(controller, model) {
    depositoParams = {}
    depositoParams.by_activo = true;
    depositoParams.unpaged = true;
    
    controller.set('control',false);

    this.store.find('deposito', depositoParams).then(function(response){
      controller.set('depositos', response);
    });
   	this.store.find('inventario',{'unpaged': true,'control': false}).then(function(response){
      controller.set('inventarios', response);
      controller.set('inventariosTemp', response);
    });
    this.store.find('inventario',{'unpaged': true,'control': true}).then(function(response){
      controller.set('inventariosControl', response);
      controller.set('inventariosControlLength', response.content.length);

    });
  }
});

Bodega.ReporteInventarios = Bodega.AuthenticatedRoute.extend({});