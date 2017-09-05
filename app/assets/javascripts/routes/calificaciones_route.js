Bodega.CalificacionesIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('calificacion', {page: 1});
  },
  
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.CalificacionRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.CalificacionEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
		return this.modelFor('calificacion');
  },
	
	setupController: function(controller, model) {
    controller.set('model', model);
  },

  renderTemplate: function() {
    this.render('calificaciones.new', {
      controller: 'calificacionEdit'
    });
  }
});

Bodega.CalificacionDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('calificacion');
  },

  renderTemplate: function() {
    this.render('calificaciones.delete', {
      controller: 'calificacionDelete'
    });
  }
});

Bodega.CalificacionesNewRoute = Bodega.AuthenticatedRoute.extend({

  model: function() {
    return this.store.createRecord('calificacion');
  }, 
	
  setupController: function(controller, model) {
    controller.set('model', model);
  }
});
