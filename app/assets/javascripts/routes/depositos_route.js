Bodega.DepositosIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('deposito', {page: 1});
  },
  
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.DepositoRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.DepositosNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    var record = this.store.createRecord('deposito');
    return record;
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('nuevoDeposito', true);
  }
});

Bodega.DepositoEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('deposito');
  },

  renderTemplate: function() {
    this.render('depositos.new', {
      controller: 'depositoEdit'
    });
  }

});

Bodega.DepositoDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('deposito');
  },

  renderTemplate: function() {
    this.render('depositos.delete', {
      controller: 'depositoDelete'
    });
  }
});