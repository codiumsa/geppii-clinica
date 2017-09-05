
Bodega.ProcesoRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.ProcesosIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('proceso', {page:1});
  },
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.ProcesoEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('proceso');
  },

  renderTemplate: function() {
    this.render('procesos.new', {
      controller: 'procesoEdit'
    });
  },
  setupController: function(controller, model) {
    controller.set('model', model);
    var producto = model.get('producto');
    var detalles = model.get('procesoDetalle');
    //console.log(detalles);
    producto.then(function function_name (argument) {
        controller.set('codigoBarraSW', producto.get('codigoBarra'));
        controller.set('descripcionProducto', producto.get('descripcion'));
        controller.set('descripcionDetalleSW', null);
        
    });

    detalles.then(function(response){
      console.log('dentro de detalles . then');
      console.log(response);
      controller.set('detalles', response);
    });
    controller.set('detNuevo', this.store.createRecord('procesoDetalle')); 
  }
});

Bodega.ProcesosNewRoute = Bodega.AuthenticatedRoute.extend({

  model: function() {
    console.log('ProcesosNewRoute');
    return this.store.createRecord('proceso');
  },
  
  setupController: function(controller, model) {
      controller.set('model', model);

      var detalles = model.get('procesoDetalle');
      
      detalles.then(function(response){
        controller.set('detalles', response);
      });

      controller.set('detNuevo', this.store.createRecord('procesoDetalle')); 
      //controller.set('ruc', '0');  
    } 
});


Bodega.ProcesoDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('proceso');
  },

  renderTemplate: function() {
    this.render('procesos.delete', {
      controller: 'procesoDelete'
    });
  },
  setupController: function(controller, model) {
    controller.set('model', model);
    var estado = model.get("estado");
    controller.set('isCancelado', estado==="CANCELADO");
  }
}); 
