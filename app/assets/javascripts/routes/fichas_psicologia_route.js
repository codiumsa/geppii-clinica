Bodega.FichaPsicologiaBaseRoute = Bodega.ClinicaBaseRoute.extend({
  setupController: function(controller, model, params) {
    this._super(controller, model, params, 'PSI');
    controller.set('model', model);
  }
});

Bodega.FichasPsicologiaNewRoute = Bodega.FichaPsicologiaBaseRoute.extend({
  queryParams: {
    paciente_id: { replace: true }
  },

  model: function() {
    this.store.find('fichaPsicologia', { page: 1 });
    var model = this.store.createRecord('fichaPsicologia');
    return model;
  },
  renderTemplate: function() {
    this.render('fichas_psicologia.new', {
      controller: 'fichasPsicologiaNew'
    });
  }
});


Bodega.FichaPsicologiaEditRoute = Bodega.FichaPsicologiaBaseRoute.extend({
  model: function(params) {
    return this.modelFor('fichaPsicologia');
  },
  renderTemplate: function() {
    this.render('fichas_psicologia.new', {
      controller: 'fichaPsicologiaEdit'
    });
  }
});
