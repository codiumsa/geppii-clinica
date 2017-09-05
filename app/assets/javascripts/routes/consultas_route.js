Bodega.ConsultasIndexRoute = Bodega.AuthenticatedRoute.extend({
  queryParams: {
    especialidad: {
      refreshModel: true
    },
    action: { replace: true },
  },
  model: function(params) {
    especialidad = params['especialidad'];
    params = {}
    params.page = 1
    params.descarta_cancelado = true;
    if (especialidad != null) {
      if (especialidad != 'all') {
        params.by_especialidad = especialidad;
      }
    }
    return this.store.find('consulta', params);
  },

  setupController: function(controller, model, params) {
    controller.set('model', model);
    controller.set('currentPage', 1);
    controller.set('staticFilters.descarta_cancelado', true);

    if(params.queryParams.especialidad == 'all'){
      controller.set('staticFilters.by_especialidad', null);
    }else if (params.queryParams.especialidad == 'ODO') {
      controller.set('staticFilters.by_especialidad', 'ODO');
    }else if (params.queryParams.especialidad == 'NUT') {
      controller.set('staticFilters.by_especialidad', 'NUT');
    }else if (params.queryParams.especialidad == 'CIR') {
      controller.set('staticFilters.by_especialidad', 'CIR');
    }else if (params.queryParams.especialidad == 'FON') {
      controller.set('staticFilters.by_especialidad', 'FON');
    }else if (params.queryParams.especialidad == 'PSI') {
      controller.set('staticFilters.by_especialidad', 'PSI');
    }
  }
});

Bodega.ConsultaRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.ConsultaEditRoute = Bodega.AuthenticatedRoute.extend({
  queryParams: {
    accion: { refreshModel: true },
  },

  model: function(params) {
    var model = this.modelFor('consulta');
    return model;
  },

  renderTemplate: function() {
    this.render('consultas/new', {
      controller: 'consultaEdit'
    });
  },

  setupController: function(controller, model, params) {
    controller.set('model', model);
    console.log('model recibido de consulta', model);
    var self = this;
    if (params.queryParams.accion) {
      controller.set('accion', String(params.queryParams.accion));
    }
    if (controller.get('accion') == 'atender') {
      controller.set('atendiendo', true);
    } else {
      controller.set('atendiendo', false);
    }
    var detalles = model.get('consultaDetalles');
    console.log("DETALLES:", detalles);
    detalles.then(function(response) {
      controller.set('detalles', response);
    });
    var listas =  model.get('consultaListas');
    listas.then(function(response) {
      controller.set('listas', response);
      console.log("listasroute",controller.get(listas));
    });

    //controller.set('detalles', detalles);
    controller.set('detNuevo', this.store.createRecord('consultaDetalle'));

    var paciente = model.get('paciente');
    paciente.then(function(response) {
      controller.set('pacienteSeleccionado', paciente.content);
      console.log("Paciente", paciente.content._data);
    });

     var especialidad = model.get('especialidad');


    this.store.find('especialidad', { unpaged: true , habilita_consulta: true}).then(function(response) {
      controller.set('especialidades', response);
    });

    especialidad.then(function(response) {
      console.log('obteniendo especialidad',response);
      controller.set('especialidadSeleccionada', response);
      self.store.find('producto', { 'unpaged': true,'by_tipo_producto': 'T','by_codigo_especialidad': response.get('codigo') }).then(function(response) {
        controller.set('tratamientos', response);
        controller.set('productoSeleccionado',response.objectAt(0));
      });
      console.log('especialidadSeleccionada',response);
      var a = '';
      a+= 'by_tipo_producto=T';
      a+= '&by_codigo_especialidad=' + response.get('codigo');
      a+= '&by_descripcion';
      console.log('Guardando queryScopeTratamientos: ', a);
      controller.set('queryScopeTratamientos', a);
    });

  }
});

Bodega.ConsultaDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('consulta');
  },

  renderTemplate: function() {
    this.render('consultas.delete', {
      controller: 'consultaDelete'
    });
  },


});

Bodega.ConsultasNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.createRecord('consulta');
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    var self = this;
    controller.set('agregandoDetalleLista',false);
    var listas =  model.get('consultaListas');

    listas.then(function(response) {
      controller.set('listas', response);
      console.log("listasroute",controller.get(listas));
    });

    var detalles = model.get('consultaDetalles');
    detalles.then(function(response) {
      controller.set('detalles', response);
    });

    controller.set('detNuevo', this.store.createRecord('consultaDetalle'));
    controller.set('detNuevoLista', this.store.createRecord('consultaLista'));

    this.store.find('especialidad',{ unpaged: true , habilita_consulta: true}).then(function(response) {
      self.controller.set('especialidades', response);
      self.controller.set('especialidadSeleccionada', response.objectAt(0));
    });

  }
});
