Bodega.CampanhasIndexRoute = Bodega.AuthenticatedRoute.extend({

  model: function() {
    return this.store.find('campanha', {by_activo:true,  page: 1});
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.CampanhaRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.CampanhaBaseRoute = Bodega.AuthenticatedRoute.extend({

});


Bodega.CampanhaEditRoute = Bodega.CampanhaBaseRoute.extend({
  model: function(params) {
    return this.modelFor('campanha');
  },

  setupController: function(controller, model) {
		controller.set('model', model);
		var estadoDefault = {};
		estadoDefault.id = model.get('estado');
		estadoDefault.nombre = model.get('estado');
		controller.set('estadoDefault', estadoDefault);
		this.store.find('tipoCampanha').then(function(response){
			controller.set('tipoCampanhas', response);
			controller.set('tipoDefault', model.get('tipoCampanha'));
		});

    var contactos = this.store.find('contacto', {'by_campanha':model.get('id')} );
    contactos.then(function(response){
      controller.set('contactos',response);
    });

  },

	renderTemplate: function() {
    this.render('campanhas.edit', {
      controller: 'campanhaEdit'
    });
  }

});

Bodega.CampanhasNewRoute = Bodega.CampanhaBaseRoute.extend({

  model: function() {
    var model = this.store.createRecord('campanha');
    return model;
  },

  setupController: function(controller, model) {
		controller.set('model', model);
		this.store.find('tipoCampanha').then(function(response){
			controller.set('tipoCampanhas', response);
			controller.set('tipoDefault', response.objectAt(0));
		});
  }
});

Bodega.CampanhaDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('campanha');
  },
	renderTemplate: function() {
    this.render('campanhas.delete', {
      controller: 'campanhaDelete'
    });
  }

});
