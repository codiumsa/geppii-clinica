Bodega.TratamientosIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('tratamiento', { page: 1 });
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.TratamientoRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.TratamientoBaseRoute = Bodega.AuthenticatedRoute.extend({
  setupCommonProps: function(controller, model) {
    controller.set('model', model);
  }
});

Bodega.TratamientoEditRoute = Bodega.TratamientoBaseRoute.extend({
  model: function(params) {
    return this.modelFor('tratamiento');
  },
  renderTemplate: function() {
    this.render('tratamientos.new', {
      controller: 'tratamientoEdit'
    });
  },
  setupController: function(controller, model) {
    controller.set('model', model);
    model.get('especialidad')
      .then(function(especialidad) {
        controller.store.find('especialidad', { unpaged: true , habilita_consulta: true}).then(function(response) {
          controller.set('especialidades', response);
          controller.set('especialidadSeleccionada', especialidad);
        });
      });
  }
});

Bodega.TratamientosNewRoute = Bodega.TratamientoBaseRoute.extend({

  model: function() {
    var model = this.store.createRecord('tratamiento');
    return model;
  },

  setupController: function(controller, model) {
    controller.set('model', model);

    this.store.find('especialidad', { unpaged: true , habilita_consulta: true}).then(function(response) {
      controller.set('especialidades', response);
      controller.set('especialidadSeleccionada', response.objectAt(0));
    });

  }
});
