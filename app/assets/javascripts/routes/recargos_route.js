Bodega.RecargoRoute = Bodega.AuthenticatedRoute.extend({ });


Bodega.RecargosIndexRoute = Bodega.AuthenticatedRoute.extend({
    model: function() {
        return this.store.find('recargo',{page: 1});
    },

    setupController: function(controller, model) {
        controller.set('model', model);
        controller.set('currentPage', 1);
        var self = this;
    }
});

Bodega.RecargoEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('recargo');
  },

  renderTemplate: function() {
    this.render('recargos.new', {
      controller: 'recargoEdit'
    });
  },

  setupController: function(controller, model) {
    controller.set('model', model);

    this.store.find('tipoCredito').then(function(response){ 
      controller.set('tipoCreditos', response);
      controller.set('tipoCreditoDefault', response.objectAt(0));
    });

    model.get('tipoCredito').then(function(response){
      controller.set('tipoCreditoSeleccionado', response);
    });

    this.store.find('medioPago').then(function(response){ 
      controller.set('medioPagos', response);
      controller.set('medioPagoDefault', response.objectAt(0));
    });

    model.get('medioPago').then(function(response){
      controller.set('medioPagoSeleccionado', response);
    });
  }
});

Bodega.RecargosNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.createRecord('recargo');
  },
  
  setupController: function(controller, model) {
    controller.set('model', model);
    this.store.find('tipoCredito').then(function(response){ 
      controller.set('tipoCreditos', response);
      controller.set('tipoCreditoDefault', response.objectAt(0));
    });

    this.store.find('medioPago').then(function(response){ 
      controller.set('medioPagos', response);
      controller.set('medioPagoDefault', response.objectAt(0));
    });
  }
});

Bodega.RecargoDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('recargo');
  },

  renderTemplate: function() {
    this.render('recargos.delete', {
      controller: 'recargoDelete'
    });
  }
});