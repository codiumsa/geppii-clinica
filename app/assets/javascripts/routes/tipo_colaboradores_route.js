Bodega.TipoColaboradoresIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('tipoColaborador', {page:1});
  },
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.TipoColaboradorRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.TipoColaboradorEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('tipoColaborador');
  },

  renderTemplate: function() {
    this.render('tipoColaboradores.new', {
      controller: 'tipoColaboradorEdit'
    });
  }
});

Bodega.TipoColaboradorDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('tipoColaborador');
  },

  renderTemplate: function() {
    this.render('tipoColaboradores.delete', {
      controller: 'tipoColaboradorDelete'
    });
  }
});

Bodega.TipoColaboradoresNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.createRecord('tipoColaborador');
  }
});