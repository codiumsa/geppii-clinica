Bodega.CajasImpresionIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('cajaImpresion', {page: 1});
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.CajaImpresionRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.CajaImpresionEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('cajaImpresion');
  },

  renderTemplate: function() {
    this.render('cajasImpresion.new', {
      controller: 'cajaImpresionEdit'
    });
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    var nombre = model.get('nombre');
  }
});

Bodega.CajaImpresionDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('cajaImpresion');
  },

  renderTemplate: function() {
    this.render('cajasImpresion.delete', {
      controller: 'cajaImpresionDelete'
    });
  }
});

Bodega.CajasImpresionNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.createRecord('cajaImpresion');
  },

  setupController: function(controller, model) {
    controller.set('model', model);
  }

});