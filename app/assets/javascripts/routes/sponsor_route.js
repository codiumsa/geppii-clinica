Bodega.SponsorsIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    console.log('SPONSOR INDEX ROUTE');
    return this.store.find('sponsor', {by_activo:true,  page: 1});
  },
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});
Bodega.SponsorRoute = Bodega.AuthenticatedRoute.extend({});
Bodega.SponsorBaseRoute = Bodega.AuthenticatedRoute.extend({
  setupCommonProps: function(controller, model) {
    controller.set('model', model);
    controller.set('tipoPersonas', ["Física", "Jurídica"]);
    controller.set('tiposSponsor', ["Mantenimiento", "Seguimiento", "Recuperación"]);
    controller.set('sexos', ['Masculino', 'Femenino']);
    controller.set('estudiosRealizados', ['Primario', 'Secundario', 'Terciario']);
    controller.set('tiposDomicilios', ['Propia', 'Alquilada', 'Familiar']);
    controller.set('estadoCivilOpts', ["Soltero/a", "Casado/a", "Divorciado/a", "Viudo/a"]);
  }
});
Bodega.SponsorEditRoute = Bodega.SponsorBaseRoute.extend({
  model: function(params) {
    return this.modelFor('sponsor');
  },
  setupController: function(controller, model) {
    this.setupCommonProps(controller, model);
    console.log(model);
    var persona = model.get('persona');
    var conyugue = persona.get('conyugue');
    console.log('PERSONA', persona);
    console.log('CONYUGUE', conyugue);
    if (!conyugue) {
      persona.set('conyugue', this.store.createRecord('conyugue'));
      console.log('PERSONA', persona);
    }
    var ciudad = persona.get('ciudad');
    this.store.find('ciudad', { unpaged: true }).then(function(response) {
      controller.set('ciudades', response);
      if (ciudad) {
        controller.set('ciudadDefault', ciudad.get('codigo'));
      } else {
        controller.set('ciudadDefault', response.objectAt(0).get('codigo'));
      }
    });
  },
  renderTemplate: function() {
    this.render('sponsors.new', {
      controller: 'sponsorEdit'
    });
  }
});
Bodega.SponsorsNewRoute = Bodega.SponsorBaseRoute.extend({
  model: function() {
    var model = this.store.createRecord('sponsor');
    var persona = this.store.createRecord('persona');
    var conyugue = this.store.createRecord('conyugue');
    persona.set('conyugue', conyugue);
    model.set('persona', persona);
    console.log(model.get('persona'));
    return model;
  },
  setupController: function(controller, model) {
    this.setupCommonProps(controller, model);
    this.store.find('ciudad', { unpaged: true }).then(function(response) {
      controller.set('ciudades', response);
      controller.set('ciudadDefault', response.objectAt(0).get('codigo'));
    });
  }
});
Bodega.SponsorDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('sponsor');
  },
  renderTemplate: function() {
    this.render('sponsors.delete', {
      controller: 'sponsorDelete'
    });
  }
});