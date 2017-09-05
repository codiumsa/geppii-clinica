Bodega.ConsultoriosIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return  this.store.find('consultorio', {page: 1});
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.ConsultorioRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.ConsultorioEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    var model = this.modelFor('consultorio');
    return model;
  },

  renderTemplate: function() {
    this.render('consultorios/new', {
      controller: 'consultorioEdit'
    });
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    var self = this;
    this.store.find('especialidad',{ unpaged: true , habilita_consulta: true}).then(function(response) {
      self.controller.set('especialidades',response);
      self.controller.set('especialidadSeleccionada', response.objectAt(0));
    });

  }
});

Bodega.ConsultorioDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('consultorio');
  },

  renderTemplate: function() {
    this.render('consultorios.delete', {
      controller: 'consultorioDelete'
    });
  },


});

Bodega.ConsultoriosNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.createRecord('consultorio');
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    var self = this;
    this.store.find('especialidad',{ unpaged: true , habilita_consulta: true}).then(function(response) {
      self.controller.set('especialidades',response);
      self.controller.set('especialidadSeleccionada', response.objectAt(0));
    });

  }
});
