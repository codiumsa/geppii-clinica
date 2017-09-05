Bodega.FichasCirugiaBaseController = Bodega.ClinicaBaseController.extend({
  queryParams: ['paciente_id', 'consulta_id'],
  paciente_id: null,
  consulta_id: null,

  habilitaUbicacionFunc: function() {
    var origenSeleccionado = this.get('origenSeleccionado');
    if (origenSeleccionado == "Con Operación Sonrisa") {
      this.set('habilitaUbicacion', true);
    } else {
      this.set('habilitaUbicacion', false);
    }
  }.observes('origenSeleccionado'),

  setFechaMision: function(){
    var habilitaMisiones = this.get('habilitaMisiones');
    var misionSeleccionada = this.get('misionSeleccionada');
    if(habilitaMisiones && misionSeleccionada != null){
      this.set('anhoController',(new Date(misionSeleccionada.get('fechaIncio'))).toString());
    }else{
      this.set('anhoController',null);
    }
  }.observes('misionSeleccionada','habilitaMisiones'),


  loadDiagnosticos: function() {
    var tipoDiagnosticoSeleccionada = this.get('tipoDiagnosticoSeleccionado');
    var diagnosticosArray = this.get('diagnosticosArray');
    var diagnosticos = [];
    if (diagnosticosArray != null && !this.get('agregandoDiagnostico')) {
      for (var i = 0; i < diagnosticosArray.length; i++) {
        if (diagnosticosArray[i].tipo == tipoDiagnosticoSeleccionada) {
          diagnosticos.push({
            "nombre": diagnosticosArray[i].nombre,
            "tiene_observacion": diagnosticosArray[i].tiene_observacion,
            "tiene_localizacion": diagnosticosArray[i].tiene_localizacion,
            "si_no": diagnosticosArray[i].si_no,
            "tiene_lados": diagnosticosArray[i].tiene_lados,
            "lados": diagnosticosArray[i].lados
          })
        }
      }
      this.set('diagnosticos', diagnosticos)
      this.set('diagnosticoSeleccionado', diagnosticos[0]);
    }
  }.observes('tipoDiagnosticoSeleccionado'),

  loadTratamientos: function() {
    var tipoTratamientoSeleccionado = this.get('tipoTratamientoSeleccionado');
    var tratamientosArray = this.get('tratamientosArray');
    var tratamientos = [];
    if (tratamientosArray != null && !this.get('agregandoTratamiento')) {
      for (var i = 0; i < tratamientosArray.length; i++) {
        if (tratamientosArray[i].tipo == tipoTratamientoSeleccionado) {
          tratamientos.push({
            "nombre": tratamientosArray[i].nombre,
            "tiene_observacion": tratamientosArray[i].tiene_observacion,
            "tiene_localizacion": tratamientosArray[i].tiene_localizacion,
            "si_no": tratamientosArray[i].si_no,
            "tiene_lados": tratamientosArray[i].tiene_lados,
            "lados": tratamientosArray[i].lados
          })
        }
      }
      this.set('tratamientos', tratamientos)
      this.set('tratamientoSeleccionado', tratamientos[0]);
    }
  }.observes('tipoTratamientoSeleccionado'),


  loadDiagnosticoSeleccionado: function() {
    var diagnosticoSeleccionado = this.get('diagnosticoSeleccionado');

    if (diagnosticoSeleccionado != null && !this.get('agregandoDiagnostico')) {
      if (diagnosticoSeleccionado.si_no) {
        this.set('tieneResultadoSatisfactorio', true);
        this.set('resultadoSatisfactorio', false);
      } else {
        this.set('tieneResultadoSatisfactorio', false);
        this.set('resultadoSatisfactorio', null);
      }
      if (diagnosticoSeleccionado.tiene_observacion) {
        this.set('tieneObservacion', true);
        this.set('observacionDiagnostico', null);
      } else {
        this.set('tieneObservacion', false);
      }

      if (diagnosticoSeleccionado.tiene_localizacion) {
        this.set('tieneLocalizacion', true);
        this.set('localizacionDiagnostico', null);

      } else {
        this.set('tieneLocalizacion', false);
      }

      if (diagnosticoSeleccionado.tiene_lados) {
        this.set('tieneLados', true);
        this.set('ladoDiagnostico', null);
      } else {
        this.set('tieneLados', false);
      }


    }
  }.observes('diagnosticoSeleccionado'),

  loadTratamientoSeleccionado: function() {
    var tratamientoSeleccionado = this.get('tratamientoSeleccionado');

    if (tratamientoSeleccionado != null && !this.get('agregandoTratamiento')) {
      if (tratamientoSeleccionado.si_no) {
        this.set('tieneResultadoSatisfactorioTratamiento', true);
        this.set('resultadoSatisfactorio', false);
      } else {
        this.set('tieneResultadoSatisfactorioTratamiento', false);
        this.set('resultadoSatisfactorioTratamiento', null);
      }
      if (tratamientoSeleccionado.tiene_observacion) {
        this.set('tieneObservacionTratamiento', true);
        this.set('observacionTratamiento', null);
      } else {
        this.set('tieneObservacionTratamiento', false);
      }

      if (tratamientoSeleccionado.tiene_localizacion) {
        this.set('tieneLocalizacionTratamiento', true);
        this.set('localizacionTratamiento', null);

      } else {
        this.set('tieneLocalizacionTratamiento', false);
      }

      if (tratamientoSeleccionado.tiene_lados) {
        this.set('tieneLados', true);
        this.set('ladoDiagnostico', null);
      } else {
        this.set('tieneLados', false);
      }


    }
  }.observes('tratamientoSeleccionado'),



  ubicacionFichaObs: function() {
    var ubicacionSeleccionada = this.get('ubicacionSeleccionada');
    if (ubicacionSeleccionada == "Misión") {
      this.set('mostrarCheckMision', true);
    } else {
      this.set('mostrarCheckMision', false);
    }
  }.observes('ubicacionSeleccionada'),

  actions: {
    agregarDiagnostico: function() {
      var listaDiagnosticos = this.get('listaDiagnosticos');
      var diagnosticoSeleccionado = this.get('diagnosticoSeleccionado');
      var tipoDiagnosticoSeleccionado = this.get('tipoDiagnosticoSeleccionado');
      this.set('agregandoDiagnostico', true);
      var detalle = this.store.createRecord('diagnosticoDetalle');
      detalle.set('nombre', diagnosticoSeleccionado.nombre);
      detalle.set('tipo', tipoDiagnosticoSeleccionado);
      var tieneObservacion = this.get('tieneObservacion');
      var tieneResultadoSatisfactorio = this.get('tieneResultadoSatisfactorio');
      var tieneLados = this.get('tieneLados');
      var tieneLocalizacion = this.get('tieneLocalizacion');

      if (tieneObservacion) {
        detalle.set('observacion', this.get('observacionDiagnostico'));
        this.set('observacionDiagnostico', null);
      }
      if (tieneResultadoSatisfactorio) {
        detalle.set('resultadoSatisfactorio', this.get('resultadoSatisfactorio'));
        this.set('resultadoSatisfactorio', false);
      } else {
        detalle.set('resultadoSatisfactorio', null);
      }
      if (tieneLados) {
        detalle.set('lado', this.get('ladoDiagnostico'));
        this.set('ladoDiagnostico', null);
      }
      if (tieneLocalizacion) {
        detalle.set('localizacion', this.get('localizacionDiagnostico'));
        this.set('localizacionDiagnostico', null);
      }
      if (tieneObservacion && tieneResultadoSatisfactorio && tieneLados && tieneLocalizacion) {
        this.set('agregarAbajo', true);
      } else {
        this.set('agregarAbajo', false);
      }
      var diagnosticos = this.get('diagnosticos');
      this.set('diagnosticoSeleccionado', diagnosticos[0]);

      var detalles = this.get('detallesDiagnosticos');
      detalles.addRecord(detalle);
      this.set('agregandoDiagnostico', false);
    },

    agregarTratamiento: function() {
      var listaTratamientos = this.get('listaTratamientos');
      var tratamientoSeleccionado = this.get('tratamientoSeleccionado');
      var tipoTratamientoSeleccionado = this.get('tipoTratamientoSeleccionado');
      var estadoSeleccionado = this.get('estadoSeleccionado');
      this.set('agregandoTratamiento', true);
      var detalle = this.store.createRecord('tratamientoDetalle');
      detalle.set('nombre', tratamientoSeleccionado.nombre);
      detalle.set('tipo', tipoTratamientoSeleccionado);
      detalle.set('estadoTratamiento', estadoSeleccionado);
      var tieneObservacion = this.get('tieneObservacionTratamiento');
      var tieneResultadoSatisfactorio = this.get('tieneResultadoSatisfactorioTratamiento');
      var tieneLados = this.get('tieneLadosTratamiento');
      var tieneLocalizacion = this.get('tieneLocalizacionTratamiento');

      if (tieneObservacion) {
        detalle.set('observacion', this.get('observacionTratamiento'));
        this.set('observacionTratamiento', null);
      }
      if (tieneResultadoSatisfactorio) {
        detalle.set('resultadoSatisfactorio', this.get('resultadoSatisfactorioTratamiento'));
        this.set('resultadoSatisfactorioTratamiento', false);
      } else {
        detalle.set('resultadoSatisfactorio', null);
      }
      if (tieneLados) {
        detalle.set('lado', this.get('ladoTratamiento'));
        this.set('ladoTratamiento', null);
      }
      if (tieneLocalizacion) {
        detalle.set('localizacion', this.get('localizacionTratamiento'));
        this.set('localizacionTratamiento', null);
      }
      if (tieneObservacion && tieneResultadoSatisfactorio && tieneLados && tieneLocalizacion) {
        this.set('agregarAbajoTratamiento', true);
      } else {
        this.set('agregarAbajoTratamiento', false);
      }
      var tratamientos = this.get('tratamientos');
      this.set('tratamientoSeleccionado', tratamientos[0]);

      var detalles = this.get('detallesTratamientos');


      var origenSeleccionado = this.get('origenSeleccionado');
      if (this.get('anhoController') != null) {
        detalle.set('anhoMision', this.get('anhoController').toString());
      }else {
        detalle.set('anhoMision',null);
      }

      if (origenSeleccionado == "Con Operación Sonrisa") {
        detalle.set('hospital', null);
        detalle.set('externo', false);
        var ubicacionSeleccionada = this.get('ubicacionSeleccionada');
        if (ubicacionSeleccionada == "Misión") {
          if (this.get('habilitaMisiones')) {
            detalle.set('campanha', this.get('misionSeleccionada').get('id'));
            //var d = new Date(this.get('misionSeleccionada').get('fechaInicio'));
            // detalle.set('anhoMision', null);
          } else {
            detalle.set('campanha', null);
            detalle.set('hospital', 'Misión OSP');
          }
        } else {
          detalle.set('hospital', 'Clinica OSP');
          detalle.set('campanha', null);
        }
      } else {
        detalle.set('hospital', this.get('hospitalTratamiento'));
        detalle.set('externo', true);
        detalle.set('campanha', null);
      }
      detalles.addRecord(detalle);
      this.set('agregandoTratamiento', false);
    },

    borrarDetalleDiagnostico: function(detalle) {
      var self = this;
      this.get('detallesDiagnosticos').removeRecord(detalle);
    },

    borrarDetalleTratamiento: function(detalle) {
      var self = this;
      this.get('detallesTratamientos').removeRecord(detalle);
    },

    save: function() {
      var self = this;
      var model = this.get('model');
      var listaDiagnosticos = this.get('detallesDiagnosticos');
      var listaTratamientos = this.get('detallesTratamientos');
      var diagnosticosRealizados = { 'diagnosticos': [] };
      var tratamientosRealizados = { 'tratamientos': [] };
      for (var i = 0; i < listaDiagnosticos.content.length; i++) {
        diagnosticosRealizados.diagnosticos.push({
          'nombre': listaDiagnosticos.content[i]._attributes.nombre,
          'tipo': listaDiagnosticos.content[i]._attributes.tipo,
          'resultadoSatisfactorio': listaDiagnosticos.content[i]._attributes.resultadoSatisfactorio,
          'observacion': listaDiagnosticos.content[i]._attributes.observacion,
          'lado': listaDiagnosticos.content[i]._attributes.lado,
          'localizacion': listaDiagnosticos.content[i]._attributes.localizacion
        });
      }
      model.set('diagnosticosRealizados', diagnosticosRealizados)

      for (var i = 0; i < listaTratamientos.content.length; i++) {
        tratamientosRealizados.tratamientos.push({
          'nombre': listaTratamientos.content[i]._attributes.nombre,
          'tipo': listaTratamientos.content[i]._attributes.tipo,
          'observacion': listaTratamientos.content[i]._attributes.observacion,
          'externo': listaTratamientos.content[i]._attributes.externo,
          'anhoMision': listaTratamientos.content[i]._attributes.anhoMision,
          'campanha': listaTratamientos.content[i]._attributes.campanha,
          'hospital': listaTratamientos.content[i]._attributes.hospital,
          'estadoTratamiento': listaTratamientos.content[i]._attributes.estadoTratamiento
        });

      }
      model.set('tratamientosRealizados', tratamientosRealizados);


      console.log('pacienteActual', this.get('pacienteActual'));
      model.set('paciente', this.get('pacienteActual'));
      model.set('consultaId', this.get('consulta_id'));
      console.log('PACIENTE', model.get('paciente'));
      delete window.localStorage.origenFicha
        // model.set('tratamientosRealizados', listaTratamientos);
      Bodega.Utils.disableElement('button[type=submit]');
      if (model.get('isValid')) {
        model.set('recienNacido', this.get('recienNacido'));
        model.save()
          .then(function(response) {
            // success
            self.store.find('paciente', { id: self.get('paciente_id') }).then(function(response) {
              if (self.get('consulta_id')) {
                self.transitionToRoute('consulta.edit', self.get('consulta_id')).then(function() {
                  Bodega.Notification.show('Éxito', 'La ficha de cirugía se ha modificado.');
                  Bodega.Utils.enableElement('button[type=submit]');
                });
              } else {
                self.transitionToRoute('paciente.edit', response.objectAt(0)).then(function() {
                  Bodega.Notification.show('Éxito', 'La ficha de cirugía se ha creado.');
                  Bodega.Utils.enableElement('button[type=submit]');
                });
              }
            });
          }, function(response) {
            console.log('ERROR: ', response);
            Bodega.Notification.show('Error', 'La ficha de cirugía no se pudo crear', 'error');
            Bodega.Utils.enableElement('button[type=submit]');
            model.transitionTo('uncommitted');
            //model.rollback();
          });
      } else {
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },
    cancel: function() {
      var model = this.get('model');
      model.deleteRecord();
      //this.transitionToRoute('fichas_odontologia');
    }
  }
});

Bodega.FichasCirugiaNewController = Bodega.FichasCirugiaBaseController.extend({
  self: this,
  queryParams: ['paciente_id'],
  paciente_id: null,
  formTitle: 'Nueva Ficha Cirugia',
  listaTratamientos: [],

});

Bodega.FichaCirugiaEditController = Bodega.FichasCirugiaBaseController.extend({
  self: this,
  queryParams: ['paciente_id'],
  paciente_id: null,
  formTitle: 'Nueva Ficha Cirugia',
  listaTratamientos: [],

});
