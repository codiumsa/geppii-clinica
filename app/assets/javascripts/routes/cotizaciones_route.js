Bodega.CotizacionRoute = Bodega.AuthenticatedRoute.extend({ });


Bodega.CotizacionesIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('cotizacion');
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.CotizacionesNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.createRecord('cotizacion');
  },
  
  setupController: function(controller, model) {
    controller.set('model', model);

    this.store.find('moneda').then(function(response){ 
      controller.set('monedas', response);
    });

    var parametros = this.store.find('parametrosEmpresa',  {'unpaged' : true});

    parametros.then(function() {
      if(parametros.objectAt(0)){
        var moneda = parametros.objectAt(0).get('moneda');
        moneda.then(function(response){
          controller.set('monedaSeleccionada', response);
        });

        var monedaBase = parametros.objectAt(0).get('monedaBase');
        monedaBase.then(function(response){
          controller.set('monedaBaseSeleccionada', response);
        });
      }
    }); 
  }
  
});