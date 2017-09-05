Bodega.TipoCreditosIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('tipoCredito', {page: 1});
  },
  setupController: function(controller, model) {
    console.log('Llamada a setup controller de tipo credito---------------');
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.TipoCreditoRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.TipoCreditoEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('tipoCredito');
  },

  renderTemplate: function() {
    this.render('tipoCreditos.new', {
      controller: 'tipoCreditoEdit'
    });
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    var unidad = model.get('unidadTiempo');

    var tipoDefault = {id: unidad};

    controller.set('unidadDefault', tipoDefault);
  }

});

Bodega.TipoCreditoDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('tipoCredito');
  },

  renderTemplate: function() {
    this.render('tipoCreditos.delete', {
      controller: 'tipoCreditoDelete'
    });
  }
});


Bodega.TipoCreditosNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.createRecord('tipoCredito');
  },

  setupController: function(controller, model) {
    controller.set('model', model);
  }

});