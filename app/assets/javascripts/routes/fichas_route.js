Bodega.FichasIndexRoute = Bodega.AuthenticatedRoute.extend({
  queryParams: {
    paciente_id: { refreshModel: true },action: { replace: true },
    especialidad: { refreshModel: true }
  },

  model: function (params) {
    paciente_id = params['paciente_id'];
    especialidad = params['especialidad'];

    params = {};
    params.page = 1;
  	params.paciente_id_fichas = paciente_id;
    tipoFicha = 'ficha' + especialidad;

    return this.store.find(tipoFicha, params);
  },

  setupController: function (controller, model,params) {
    console.log('params');
    console.log(params.queryParams.especialidad);
    controller.set('model', model);
    controller.set('currentPage', 1);
    controller.set('especialidad', params.queryParams.especialidad);
    console.log(controller.get('especialidad'));
    controller.set('paciente', params.queryParams.paciente_id);
    controller.set('linkEspecialidad', 'ficha'+params.queryParams.especialidad);
    console.log(controller.get('linkEspecialidad'));
  },

});

Bodega.FichaRoute = Bodega.AuthenticatedRoute.extend({});
