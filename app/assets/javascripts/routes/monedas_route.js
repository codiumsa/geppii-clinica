Bodega.MonedaRoute = Bodega.AuthenticatedRoute.extend({ });


Bodega.MonedasIndexRoute = Bodega.AuthenticatedRoute.extend({
    model: function() {
        return this.store.find('moneda',{page: 1});
    },

    setupController: function(controller, model) {
        controller.set('model', model);
        controller.set('currentPage', 1);
        var self = this;
    }
});

Bodega.MonedaEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('moneda');
  },

  renderTemplate: function() {
    this.render('monedas.new', {
      controller: 'monedaEdit'
    });
  },

  setupController: function(controller, model) {
      controller.set('model', model);
  }

});

Bodega.MonedasNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.createRecord('moneda');
  },
  
  setupController: function(controller, model) {
      controller.set('model', model);
  }
  
});

Bodega.MonedaDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('moneda');
  },

  renderTemplate: function() {
    this.render('monedas.delete', {
      controller: 'monedaDelete'
    });
  }
});