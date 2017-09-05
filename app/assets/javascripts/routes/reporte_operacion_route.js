Bodega.ReporteOperacionIndexRoute = Bodega.AuthenticatedRoute.extend({
  setupController: function(controller, model) {

	this.store.find('caja', {'unpaged':true}).then(function(response){
      controller.set('cajas', response);
    });

    var tiposOperacion = this.store.find('tipoOperacion');

    tiposOperacion.then(function() {
      console.log("tiposOperacion.then -> Obteniendo tipos de operacion");
      controller.set('tiposOperacion', tiposOperacion);
    });
   
  }
});

Bodega.ReporteOperacion = Bodega.AuthenticatedRoute.extend({});