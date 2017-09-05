Bodega.ColaboradoresIndexRoute = Bodega.AuthenticatedRoute.extend({

  model: function() {
    return this.store.find('colaborador', { by_activo: true, page: 1 });
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.ColaboradorRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.ColaboradorBaseRoute = Bodega.AuthenticatedRoute.extend({

  setupCommonProps: function(controller, model) {
    console.log('MODEL COLABORADOR: ', model);
    model.set('activo', true);
    controller.set('model', model);
    controller.set('tipoPersonas', ["Física", "Jurídica"]);
    controller.set('sexos', ['Masculino', 'Femenino']);
    controller.set('estudiosRealizados', ['Primario', 'Secundario', 'Terciario']);
    controller.set('tiposDomicilios', ['Propia', 'Alquilada', 'Familiar']);
    controller.set('estadoCivilOpts', ["Soltero/a", "Casado/a", "Divorciado/a", "Viudo/a"]);
    controller.set('campanhaSeleccionadaSW', null);
    controller.set('descripcionSW', null);
    controller.set('campanhaNueva', this.store.createRecord('campanhaColaborador'));
    controller.set('count', 0);
    controller.set('tipoPersonas',['Física','Jurídica']);
    controller.set('habilitaTipoPersona',false);



    var campanhas = model.get('campanhasColaboradores');
    console.log('Campanhas', campanhas);
    campanhas.then(function(response){
      console.log("Seteando Campanhas: ", response);
      controller.set('campanhas', response);
    });

  }
});


Bodega.ColaboradorEditRoute = Bodega.ColaboradorBaseRoute.extend({
  model: function(params) {
    return this.modelFor('colaborador');
  },

  setupController: function(controller, model) {
    this.setupCommonProps(controller, model);
    console.log("Seteando persona....");
    var persona = model.get('persona');
    var conyugue = persona.get('conyugue');

    if (!conyugue) {
      console.log("Seteando conyugue....", conyugue);
      conyugue = this.store.createRecord('conyugue');
      persona.set('conyugue', conyugue);
      console.log("Conyugue final:", conyugue);
    }

    this.store.find('viaje', { by_colaborador_id: model.get('id') }).then(function(response) {
      controller.set('viajes',response);
      console.log('response.length > 0)', response.content.length > 0);
      console.log('response)', response);
      controller.set('tieneViaje',response.content.length > 0);
    });

    this.store.find('curso', { by_colaborador_id: model.get('id') }).then(function(response) {
      controller.set('cursos',response);
      controller.set('tieneCurso',response.content.length > 0);
    });




    var ciudad = persona.get('ciudad');
    this.store.find('ciudad', { unpaged: true }).then(function(response) {
      controller.set('ciudades', response);
      console.log('Seteando ciudades: ', response);
      if (ciudad) {
        ciudad.then(function(response) {
          console.log('Seteando ciudad: ', response);
          controller.set('ciudadDefault', response);
          console.log(controller.get('ciudadDefault'));
        });
      } else {
        controller.set('ciudadDefault', response.objectAt(0));
      }
    });

    var tipoColaborador = model.get('tipoColaborador');
    var tipoColaboradores = this.store.find('tipoColaborador', { unpaged: true });
    tipoColaboradores.then(function(response) {
      controller.set('tipoColaboradores', tipoColaboradores);
      if (tipoColaborador) {
        tipoColaborador.then(function(response) {
          controller.set('tipoColaboradorSeleccionado', response);
        });
      } else {
        //console.log('Seteando el tipo colaborador DEFAULT...', tipoColaboradores.objectAt(0));
        controller.set('tipoColaboradorSeleccionado', tipoColaboradores.objectAt(0));
      }
    });


    var especialidad = model.get('especialidad');
    var especialidades = this.store.find('especialidad', { unpaged: true });
    especialidades.then(function(response) {
      controller.set('especialidades', especialidades);
      if (especialidad) {
        especialidad.then(function(response) {
          controller.set('especialidadSeleccionada', response);
        });
      } else {
        //console.log('Seteando la especialidad DEFAULT...', especialidades.objectAt(0));
        controller.set('especialidadSeleccionada', especialidades.objectAt(0));
      }
    });

  },

  renderTemplate: function() {
    this.render('colaboradores.new', {
      controller: 'colaboradorEdit'
    });
  }
});

Bodega.ColaboradoresNewRoute = Bodega.ColaboradorBaseRoute.extend({

  model: function() {
    var model = this.store.createRecord('colaborador');
    var persona = this.store.createRecord('persona');
    var conyugue = this.store.createRecord('conyugue');
    persona.set('conyugue', conyugue);
    model.set('persona', persona);
    //console.log(model.get('persona'));

    return model;
  },

  setupController: function(controller, model) {

    this.setupCommonProps(controller, model);

    this.store.find('ciudad', { unpaged: true }).then(function(response) {
      controller.set('ciudades', response);
      controller.set('ciudadDefault', response.objectAt(0));
    });

    this.store.find('tipoColaborador', { unpaged: true }).then(function(response) {
      controller.set('tipoColaboradores', response);
      controller.set('tipoColaboradorSeleccionado', response.objectAt(0));
    });

    this.store.find('especialidad', { unpaged: true }).then(function(response) {
      controller.set('especialidades', response);
      controller.set('especialidadSeleccionada', response.objectAt(0));
    });

  }
});

Bodega.ColaboradorDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('colaborador');
  },

  renderTemplate: function() {
    this.render('colaboradores.delete', {
      controller: 'colaboradorDelete'
    });
  }
});
