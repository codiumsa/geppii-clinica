Bodega.ClinicaBaseRoute = Bodega.AuthenticatedRoute.extend({
  queryParams: {
    paciente_id: { replace: true },
    consulta_id: { replace: true },
  },
  //
  // willTransition: function(transition) {
  //   $('body').removeClass('modal-open');
  //   var appController = this.controllerFor('application');
  //   appController.set('containerHeight', Bodega.newHeightWrapper(true));
  //   var model = this.get('currentModel');
  //   if (model && model.get('isDirty')) {
  //     if (true) {
  //       //Stay on same page and continue editing
  //       //transition.abort();
  //    // } else {
  //       //Delete created record
  //       var model = this.get('currentModel');
  //       if (!model.get('id')) {
  //         model.deleteRecord();
  //       } else {
  //         model.rollback();
  //       }
  //     }
  //   }
  // },

  setupController: function(controller, model, params, especialidad) {
    console.log('ClinicaBaseRoute', params);

    console.log('ClinicaBaseRoute....', params);
    var origenFicha = window.localStorage.getItem("origenFicha");
    if (origenFicha == 'indexFichas') {
      controller.set('habilitaGuardar',false);
    }else if(origenFicha == 'noIndexFichas') {
      controller.set('habilitaGuardar',true);
    }

    this._super(controller, model);
    if (params && params.queryParams.paciente_id) {
      console.log("Paciente Recibido: ", params.queryParams.paciente_id);
      controller.set('paciente_id', params.queryParams.paciente_id);
      var pacienteActual = this.store.find('paciente', { by_id: params.queryParams.paciente_id });
      pacienteActual.then(function(response) {
        controller.set('pacienteActual', pacienteActual.objectAt(0));
      });
    } else {
      var pacienteActual = this.store.find('paciente', { by_id: controller.get('model').get('paciente').get('id') });
      pacienteActual.then(function(response) {
        controller.set('pacienteActual', pacienteActual.objectAt(0));
      });
    }
    if (params && params.queryParams.consulta_id) {
      var consulta_id = params.queryParams.consulta_id;
      console.log('CONSULTA ID RECIBIDO:', params.queryParams.consulta_id == "undefined");
      if (params.queryParams.consulta_id == "undefined") {
        console.log('---------------> Seteando consulta_id a null');
        controller.set('consulta_id', null);
      }else{
        console.log('---------------> Seteando consulta id...')
        controller.set('consulta_id', params.queryParams.consulta_id);
      }
    }

    if (controller.get('consulta_id')) {
      console.log('---------------> Se obtuvo consulta_id.....', controller.get('consulta_id'));
      var consulta = controller.store.getById('consulta', controller.get('consulta_id') );
      consulta.reload().then(function(response) {
        console.log(response);
        var especialidad = response.get('especialidad');
        var nro_ficha = response.get('nroFicha');

        especialidad.then(function(){
          console.log("especialidad ",especialidad.get('id'));
          console.log("nro_ficha ",nro_ficha);
          if(nro_ficha != null){
            var consultas = controller.store.find('consulta', { 'by_nro_ficha': String(nro_ficha), 'by_especialidad_id': especialidad.get('id') });
            consultas.then(function(response) {
              controller.set('consultas', response);
              if(response.content.length > 1){
                controller.set('mostrarSiguiente',true);
              }else {
                controller.set('mostrarSiguiente',false);
              }
              controller.set('mostrarAnterior',false);
              controller.set('posConsultaDetalle',0)
              controller.set('consultaActual', response.objectAt(0));
              response.objectAt(0).get('consultaDetalles').then(function(consultaDetallesTemp){
                controller.set('consultaDetallesActual',consultaDetallesTemp);
              });
              console.log('consultaActual',response.objectAt(0));
              console.log('consultas', controller.get('consultas'));
            });
          }else {
            console.log('no se existe nro ficha');
            controller.set('consultas', null);
          }
        });
      });
    } else {
      //var especialidad = controller.get('model').get('especialidad');
      var consultas = controller.store.find('consulta', { by_especialidad: especialidad, by_estado_actual: 'VIGENTE' });
      consultas.then(function(response) {
        controller.set('consultas', response);
        console.log('consultas', controller.get('consultas'));
      });
    }


  }
});
