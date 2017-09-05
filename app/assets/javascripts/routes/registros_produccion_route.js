Bodega.RegistrosProduccionIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('registroProduccion', {page: 1});
  },
  
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  },
  // renderTemplate: function() {
  //   this.render('registrosProduccion.index', {controller: 'registrosProduccionIndex'});
  // }
});

Bodega.RegistroProduccionRoute = Bodega.AuthenticatedRoute.extend({});
Bodega.RegistroProduccionLoadingRoute = Ember.Route.extend();

Bodega.RegistroProduccionEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    console.log('edit registroProduccion');
    return this.modelFor('registroProduccion');
  },

  renderTemplate: function() {
    this.render('registrosProduccion.new', {
      controller: 'registroProduccionEdit'
    });
  },
  setupController: function(controller, model) {
    controller.set('model', model);
    this.store.find('proceso', {by_producible: 'VIGENTE'}).then(function(response){ 
      controller.set('procesos', response);
      controller.set('procesoDefault', controller.get('model').get('proceso'));
      controller.get('model').get('proceso').get('producto').then(function() {
        controller.set('descripcionProducto', controller.get('model').get('proceso').get('producto').get('descripcion'));
      });
    });

    this.store.find('deposito').then(function(response){ 
      controller.set('depositos', response);
      controller.set('depositoDefault', controller.get('model').get('deposito'));
    });
    console.log(controller.get('model').get('isIniciado'));
  }
});


Bodega.RegistroProduccionDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    console.log('delete registroProduccion');
    return this.modelFor('registroProduccion');
  },

  renderTemplate: function() {
    this.render('registrosProduccion.delete', {
      controller: 'registroProduccionDelete'
    });
  }
});

Bodega.RegistrosProduccionNewRoute = Bodega.AuthenticatedRoute.extend({

  model: function() {
    console.log('Creando modelo registroProduccion');
    return this.store.createRecord('registroProduccion');
  },
  renderTemplate: function() {
    this.render('registrosProduccion.new', {
      controller: 'registrosProduccionNew'
    });
  },

  setupController: function(controller, model) {
    model.set('estado', 'REGISTRADO');
    controller.set('model', model);
    this.store.find('proceso', {by_producible: 'VIGENTE'}).then(function(response){ 
      controller.set('procesos', response);
      controller.set('procesoDefault', response.objectAt(0));
      if (controller.get('procesoDefault')){
        controller.set('descripcionProducto', controller.get('procesoDefault').get('producto').get('descripcion'));
      }else{
        controller.set('descripcionProducto', 'No existen procesos de producción');
      }
    });

    this.store.find('deposito').then(function(response){ 
      controller.set('depositos', response);
      controller.set('depositoDefault', response.objectAt(0));
    });

  }
});
// controller.set('isCancelado', estado==="CANCELADO");