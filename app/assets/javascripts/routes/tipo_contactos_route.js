Bodega.TipoContactosIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return  this.store.find('tipoContacto', {page: 1, by_activo: true});
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.TipoContactoRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.TipoContactoEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('tipoContacto');
  },

  renderTemplate: function() {
    this.render('tipoContactos/new', {
      controller: 'tipoContactoEdit'
    });
  }
});

Bodega.TipoContactoDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('tipoContacto');
  },

  renderTemplate: function() {
    this.render('tipoContactos.delete', {
      controller: 'tipoContactoDelete'
    });
  }
});

Bodega.TipoContactosNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.createRecord('tipoContacto');
  }
});