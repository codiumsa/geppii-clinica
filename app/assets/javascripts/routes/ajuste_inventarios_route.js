
Bodega.AjusteInventarioRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.AjusteInventariosIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('ajusteInventario', {page: 1});
  },
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.AjusteInventarioEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('ajusteInventario');
  },

  renderTemplate: function() {
    this.render('ajusteInventarios.new', {
      controller: 'ajusteInventarioEdit'
    });
  },

  setupController: function(controller, model) {
      controller.set('model', model);
      controller.set('edit', true);

      var detalles = model.get('detalle');

      detalles.then(function(response){
        controller.set('detalles', response);
      });
      controller.set('detNuevo', this.store.createRecord('ajusteInventarioDetalle'));

      this.store.find('deposito').then(function(response){
        controller.set('depositos', response);
        controller.set('depositoDefault', response.objectAt(0));
      });

      model.get('deposito').then(function(response){
        controller.set('depositoSeleccionado', response);
      });
    }

});

Bodega.AjusteInventariosNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.createRecord('ajusteInventario');
  },

  setupController: function(controller, model) {
      controller.set('model', model);
      controller.set('habilitaLote', false);
      controller.set('habilitaAgregar',false);
      controller.set('existencia',null);

      var detalles = model.get('detalle');

      detalles.then(function(response){
        controller.set('detalles', response);
      });
      this.store.find('motivosInventario').then(function(response){
        controller.set('motivos', response);
        controller.set('motivoSeleccionado', response.objectAt(0));
      });
      controller.set('detNuevo', this.store.createRecord('ajusteInventarioDetalle'));
      this.store.find('deposito').then(function(response){
        controller.set('depositos', response);
        controller.set('depositoDefault', response.objectAt(0));
      });
    }


});
