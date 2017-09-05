
Bodega.MotivosInventarioRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.MotivosInventariosIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('motivosInventario', {page: 1});
  },
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.MotivosInventarioEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('motivosInventario');
  },

  renderTemplate: function() {
    this.render('motivosInventarios/new', {
      controller: 'motivosInventarioEdit'
    });
  },

  setupController: function(controller, model) {
      controller.set('model', model);
      controller.set('edit', true);
    }

});


Bodega.MotivosInventarioDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('motivosInventario');
  },

  renderTemplate: function() {
    this.render('motivosInventarios/delete', {
      controller: 'motivosInventarioDelete'
    });
  }
});

Bodega.MotivosInventariosNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.createRecord('motivosInventario');
  },

  setupController: function(controller, model) {
      controller.set('model', model);
    }


});
