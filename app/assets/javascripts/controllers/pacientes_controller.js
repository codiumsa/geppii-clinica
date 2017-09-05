//en PacientesIndexController van las funciones que manejan el index.hbs


Bodega.PacientesIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable,
  Bodega.mixins.Filterable, {
    resource: 'paciente',
    hasSearchForm: true,
    searchFormTpl: 'pacientes/searchform',
    searchFormModal: '#pacienteSearchForm',
    perPage: 9,
    staticFilters: {
      ignorar_paciente_default: true
    },
    filterToParam: {
      by_numero_paciente: 'by_numero_paciente',
      by_ciRuc: 'by_ciRuc',
      by_razon_social: 'by_razon_social',
      by_sexo: 'by_sexo',
      by_tipo_persona: 'by_tipo_persona',
      by_estado_civil: 'by_estudios_realizados',
      by_nacionalidad: 'by_nacionalidad',
      by_ciudad: 'by_ciudad',
      by_barrio: 'by_barrio',
      by_fecha_nacimiento_before: 'by_fecha_nacimiento_before',
      by_fecha_nacimiento_on: 'by_fecha_nacimiento_on',
      by_fecha_nacimiento_after: 'by_fecha_nacimiento_after'
    },
    clearSearchForm: function () {
      var self = this;
      Ember.keys(self.filterToParam).forEach(function (f) {
        self.set(f, '');
      });
    },
    actions: {
      criteriaSearch: function () {
        var self = this;
        var ciRuc = this.get('ciRuc');
        var nroPaciente = this.get('nroPaciente');
        var filters = this.get('filters');

        Ember.keys(self.filterToParam).forEach(function (f) {
          var value = self.get(f);
          if (value) {
            filters[self.filterToParam[f]] = value;
          }
        });

        this.set('filters', filters);
        this.store.find('paciente', filters).then(function (model) {
          self.set('model', model);
        });
      },
      goEditPaciente: function (id) {
        var paciente = this.store.find('paciente', id);
        this.transitionTo("paciente.edit", paciente);
      }
    }
  });

Bodega.PacienteBaseController = Bodega.ClinicaBaseController.extend({
  queryParams: ['ref'],
  ref: null,
  needs: ['application'],
  formTitle: '',
  numeral: '#',
  tipoPersonas: [],
  jubiladoComercianteOpts: [],
  tiposReferencia: [],
  estadoCivilOpts: [],
  perfilLaboral: '',
  perfilesLaborales: [],
  sexos: [],
  estudiosRealizados: [],
  tiposDomicilios: [],
  cirugiaNueva: null,
  medicamentoNuevo: null,
  alergiaNueva: null,
  maxDetalles: 33,
  imgMissing: '/images/missing_small.png',
  feedback: Ember.Object.create(),

  datosImportantes: null,
  listaAlergias: Ember.computed('datosImportantes.alergias.@each.eliminado', function () {
    return this.get('datosImportantes.alergias').filterBy('eliminado', false);
  }),
  listaCirugias: Ember.computed('datosImportantes.cirugias.@each.eliminado', function () {
    return this.get('datosImportantes.cirugias').filterBy('eliminado', false);
  }),
  listaMedicamentos: Ember.computed('datosImportantes.medicamentos.@each.eliminado', function () {
    return this.get('datosImportantes.medicamentos').filterBy('eliminado', false);
  }),

  edadObserver: function () {
    var fecha = this.get('persona.fechaNacimiento');
    console.log('fecha',fecha);
    if (fecha) {
      var nac = moment(fecha.toString());
      var hoy = moment();
      var edad = hoy.diff(nac,'years') // 86400000
      this.set('persona.edad',edad);
      console.log('edad',edad);
    }
  }.observes('persona.fechaNacimiento'),

  misionAsociadaVinculosObserver: function () {
    var misionAsociadaVinculos = this.get('vinculos.misionAsociada');
    if (misionAsociadaVinculos == 'si') {
      this.set('misionAsociadaVinculos', true);
    } else {
      this.set('misionAsociadaVinculos', false);
    }
  }.observes('vinculos.misionAsociada'),

  loadDiagnosticos: function () {
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

  loadTratamientos: function () {
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


  detalleFuenteObserver: function () {
    if (this.get('vinculos.comoSeEntero')) {
      var fuente = this.get('vinculos.comoSeEntero.fuente');
      if (fuente == 'Hospital' || fuente == 'Otros') {
        this.set('muestraDetalleFuente', true);
      } else {
        this.set('muestraDetalleFuente', false);
        this.set('vinculos.comoSeEntero.detalle', '');
      }
    }

  }.observes('vinculos.comoSeEntero.fuente'),

  save: function () {
    var model = this.get('model');
    var self = this;
    var feedback = this.get('feedback');
  },

  getNewModel: function (newField) {
    if (newField === 'cirugiaNueva') {
      return Ember.Object.create({
        clinica: null,
        fecha: null,
        lugar: null,
        obs: null,
        eliminado: false
      });
    } else if (newField === 'medicamentoNuevo') {
      return Ember.Object.create({
        medicamento: null,
        frecuencia: null,
        motivo: null,
        eliminado: false
      });
    } else if (newField === 'alergiaNueva') {
      return Ember.Object.create({
        fecha: null,
        alergia: null,
        eliminado: false
      });
    } else {
      return null;
    }
  },
  pushArray: function (arr, arr2) {
    return arr.concat(arr2);
  },

  actions: {
    agregarMisionVinculo: function () {
      var misionVinculoSeleccionada = this.get('misionVinculoSeleccionada');
      this.set('agregandoMisionVinculo', true);
      var detalle = this.store.createRecord('misionVinculo');
      detalle.set('nombre', misionVinculoSeleccionada.get('nombre'));
      detalle.set('descripcion', misionVinculoSeleccionada.get('descripcion'));
      if(this.get('tieneDiagnostico')){
        console.log('tiene diagnostico, el seleccionado es',this.get('diagnosticoSeleccionado.nombre'));
        console.log('tiene diagnostico, su tipo es ',this.get('tipoDiagnosticoSeleccionado'));
        detalle.set('tipoDiagnostico',this.get('tipoDiagnosticoSeleccionado'));
        detalle.set('diagnostico',this.get('diagnosticoSeleccionado.nombre'));
      }else{
        detalle.set('tipoDiagnostico',null);
        detalle.set('diagnostico',null);
      }
      if(this.get('tieneTratamiento')){
        detalle.set('tipoTratamiento',this.get('tipoTratamientoSeleccionado'));
        detalle.set('tratamiento',this.get('tratamientoSeleccionado.nombre'));
      }else{
        detalle.set('tipoTratamiento',null);
        detalle.set('tratamiento',null)
      }
      detalle.set('motivoNoSeOpero',this.get('motivoNoSeOpero'));
      detalle.set('recomendacionDental',this.get('recomendacionDental'));
      detalle.set('recomendacionFonoaudiologica',this.get('recomendacionFonoaudiologica'));

      var detalles = this.get('misionesVinculo');
      detalles.addRecord(detalle);
      console.log('detalles',detalles);
      this.set('agregandoMisionVinculo', false);
    },

    borrarMisionVinculo: function (detalle) {
      var self = this;
      this.get('misionesVinculo').removeRecord(detalle);
    },

    loadPersona: function () {
      console.log('LOAD PACIENTE IF EXIST ');
      var personaId = this.get('persona.id');
      if (!personaId) {
        var ruc = this.get('persona.ciRuc');
        var self = this;
        var model = self.get('model');
        if (ruc) {
          var personas = self.store.find('persona', {
            'by_ciRuc': ruc
          });

          personas.then(function () {
            var persona = personas.objectAt(0);
            if (persona) {
              var pacientes = self.store.find('paciente', {
                'by_persona_id': persona.get('id')
              });
              pacientes.then(function () {
                var paciente = pacientes.objectAt(0);
                if (paciente) {
                  console.log('Ir a edición de paciente con CI: ', persona.get('ci_ruc'));
                  self.transitionToRoute("paciente.edit", paciente);
                }
              });
              console.log("Seteando persona....");
              var conyugue = persona.get('conyugue');
              if (!conyugue) {
                console.log("Seteando conyugue....", conyugue);
                conyugue = self.store.createRecord('conyugue');
                persona.set('conyugue', conyugue);
                console.log("Conyugue final:", conyugue);
              }
              model.set('persona', persona);
              model.set('idPersona', persona.get('id'));
              //self.set('model', model);
            }
          });
        }
      }
    },
    loadPaciente: function () {
      console.log('LOAD PACIENTE IF EXIST ');
      var nroPaciente = this.get('numeroPaciente');
      var self = this;
      var model = self.get('model');
      if (nroPaciente) {
        var pacientes = self.store.find('paciente', {
          'by_numero_paciente': nroPaciente
        });
        pacientes.then(function () {
          var paciente = pacientes.objectAt(0);
          if (paciente) {
            console.log('Ir a edición de paciente con NRO: ', nroPaciente);
            self.transitionToRoute("paciente.edit", paciente);
          }
        });
      }
    },
    agregarDetalle: function (fieldModel, newField) {
      console.log('PacientesBaseController->agregarDetalle');
      var detalle = this.get(newField);
      console.log('DETALLE NUEVO', detalle);
      var agregar = true;
      if (agregar) {
        this.set(newField, this.getNewModel(newField));
        if (!this.get(fieldModel)) {
          this.set(fieldModel, []);
        }
        this.get(fieldModel).pushObject(detalle);
        //$("#fecha").focus();
      }
    },

    borrarDetalle: function (detalle, fieldModel, fieldController) {
      console.log(detalle);
      detalle.eliminado = true;
      this.get(fieldModel).slice();
      this.propertyDidChange(fieldController);
      console.log("PacientesBaseController->borrarDetalle - Lista: ", this.get(fieldModel));
      this.get('controllers.application').set('containerHeighPt', Bodega.newHeightWrapper());
    },
  }
});

Bodega.PacientesNewController = Bodega.PacienteBaseController.extend({
  formTitle: 'Nuevo Paciente',
  actions: {
    save: function () {
      var model = this.get('model');
      var self = this;
      if (this.get('persona.fechaNacimiento') == null) {
        Bodega.Notification.show('Error', 'Ingrese la fecha de nacimiento del paciente',
          Bodega.Notification.ERROR_MSG);
          return;
      }
      Bodega.Utils.disableElement('button[type=submit]');
      //this.set('persona.datosFamiliares', {});
      this.set('persona.tipoPersona', "Física");
      this.set('persona.razonSocial', this.get('persona.nombre') +
        ' ' + this.get('persona.apellido'));

      model.set('datosFamiliares', this.get('datosFamiliares'));
      model.set('contactoEmergencia', this.get('contactoEmergencia'));



      var vinculos = this.get('vinculos');
      var misionesAsociadas = vinculos.misionAsociada
      var misionesVinculo = this.get('misionesVinculo');

      if (misionesVinculo.length > 0) {
        var misionesTemp = {
          'misiones': []
        };
        var misionesTemp = [];
        for (var i = 0; i < misionesVinculo.content.length; i++) {
          misionesTemp.push({
            'nombre': misionesVinculo.content[i]._attributes.nombre,
            'descripcion': misionesVinculo.content[i]._attributes.descripcion,
            'tipoDiagnostico': misionesVinculo.content[i]._attributes.tipoDiagnostico,
            'diagnostico': misionesVinculo.content[i]._attributes.diagnostico,
            'tipoTratamiento': misionesVinculo.content[i]._attributes.tipoTratamiento,
            'tratamiento': misionesVinculo.content[i]._attributes.tratamiento,
            'motivoNoSeOpero': misionesVinculo.content[i]._attributes.motivoNoSeOpero,
            'recomendacionDental': misionesVinculo.content[i]._attributes.recomendacionDental,
            'recomendacionFonoaudiologica': misionesVinculo.content[i]._attributes.recomendacionFonoaudiologica
          });
        }
        vinculos.misiones = misionesTemp;
        model.set('vinculos', vinculos);
        model.set('vinculos.misionAsociada', "si");
      } else {
        vinculos.misiones = {}
      }
      model.set('vinculos', vinculos);



      model.set('otrosDatos', this.get('otrosDatos'));

      model.set('datosImportantes', this.get('datosImportantes'));

      if (model.get('isValid')) {
        model.save().then(function (response) {
          // success
          self.set('model', response);
          self.transitionToRoute('pacientes').then(function () {
            Bodega.Notification.show('Exito', 'El paciente se ha guardado.');
            Bodega.Utils.enableElement('button[type=submit]');
          });
        }, function (response) {
          //error
          console.log(response);
          self.set('feedback', response.errors);
          Bodega.Notification.show('Error', 'No se pudo crear el paciente.',
            Bodega.Notification.ERROR_MSG);
          Bodega.Utils.enableElement('button[type=submit]');
        });
      } else {
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },
    cancel: function () {
      var model = this.get('model');
      model.deleteRecord();
      this.transitionToRoute('pacientes');
    }
  }
});

/* se pasa como parametro la especialidad en lowercase y singular
   ej: odontologia, fonoaudiologia
*/
var goEditFicha = function (controller, especialidad) {
  var paciente = controller.get('model');
  var fichas = controller.store.find('ficha_' + especialidad, {
    paciente_id: paciente.get('id')
  });
  var ficha;
  fichas.then(function (obj) {
    ficha = obj.objectAt(0);
    var upEspecialidad = especialidad[0].toUpperCase() + especialidad.substr(1, especialidad.length);
    if (ficha === undefined || ficha === null || ficha.get('id') === undefined) {
      console.log("paciente ");
      console.log(paciente.get('id'));
      controller.transitionToRoute('fichas' + upEspecialidad + '.new', {
        queryParams: {
          paciente_id: paciente.get('id')
        }
      });
    } else {
      controller.transitionToRoute('ficha' + upEspecialidad + '.edit', ficha);
    }
  });
};


Bodega.PacienteEditController = Bodega.PacienteBaseController.extend({

  formTitle: 'Editar Paciente',
  isEdit: true,

  changeEspecialidad: function(){
    var especialidadSeleccionada = this.get('especialidadSeleccionada');
    var self = this;
    if (especialidadSeleccionada) {
      this.store.find('colaborador', {'unpaged': true, 'by_especialidad_id': especialidadSeleccionada.get('id'),'by_activo':true}).then(function (response) {
        self.set('colaboradores', response);
        self.set('colaboradorDefault', response.objectAt(0));
        self.set('colaboradorSeleccionado', response.objectAt(0));
      });
    }
  }.observes('especialidadSeleccionada'),

  changedMediante: function () {
    if (!this.get('medianteSeleccionado')) {
      return;
    }
    if (this.get('medianteSeleccionado').descripcion === "Clínica") {
      this.set("medianteClinica", true);
    } else {
      this.set("medianteClinica", false);
    }
    if (this.get('medianteSeleccionado').descripcion === "Misión") {
      this.set("medianteMision", true);
    } else {
      this.set("medianteMision", false);
    }
  }.observes('medianteSeleccionado'),

  actions: {
    save: function () {
      var model = this.get('model');
      var self = this;
      //var modelsFileUploadMap = {};
      Bodega.Utils.disableElement('button[type=submit]');


    if (this.get('persona.fechaNacimiento') == null) {
      Bodega.Notification.show('Error', 'Ingrese la fecha de nacimiento del paciente',
        Bodega.Notification.ERROR_MSG);
        return;
    }

      var mostrarRazonSocial = this.get('mostrarRazonSocial');
      if (!mostrarRazonSocial) {
        this.set('persona.razonSocial', this.get('persona.nombre') + ' ' + this.get('persona.apellido'));
      }
      model.set('datosFamiliares', this.get('datosFamiliares'));
      model.set('contactoEmergencia', this.get('contactoEmergencia'));


      var vinculos = this.get('vinculos');
      var misionesAsociadas = vinculos.misionAsociada
      var misionesVinculo = this.get('misionesVinculo');
      if (misionesVinculo.content.length > 0) {
        var misionesTemp = {
          'misiones': []
        };
        var misionesTemp = [];
        for (var i = 0; i < misionesVinculo.content.length; i++) {
          misionesTemp.push({
            'nombre': misionesVinculo.content[i]._attributes.nombre,
            'descripcion': misionesVinculo.content[i]._attributes.descripcion,
            'tipoDiagnostico': misionesVinculo.content[i]._attributes.tipoDiagnostico,
            'diagnostico': misionesVinculo.content[i]._attributes.diagnostico,
            'tipoTratamiento': misionesVinculo.content[i]._attributes.tipoTratamiento,
            'tratamiento': misionesVinculo.content[i]._attributes.tratamiento,
            'motivoNoSeOpero': misionesVinculo.content[i]._attributes.motivoNoSeOpero,
            'recomendacionDental': misionesVinculo.content[i]._attributes.recomendacionDental,
            'recomendacionFonoaudiologica': misionesVinculo.content[i]._attributes.recomendacionFonoaudiologica
          });
        }
        console.log('misiones',misionesTemp);
        vinculos.misiones = misionesTemp;
        model.set('vinculos', vinculos);
      } else {
        vinculos.misiones = {}
      }
      model.set('vinculos', vinculos);
      model.set('otrosDatos', this.get('otrosDatos'));

      var datosImportantes =  this.get('datosImportantes');
      console.log('datosimportantesantesdeguardar',datosImportantes.cirugias);
      if(datosImportantes.cirugias.length > 0){

        for (var i = 0; i < datosImportantes.cirugias.length; i++) {
          if (datosImportantes.cirugias[i].eliminado == true){
            datosImportantes.cirugias.splice(i,1);
          }
        }
      }
      console.log('datosimportantesaguardar',datosImportantes.cirugias);
      this.set('datosImportantes.cirugias',datosImportantes.cirugias);
      model.set('datosImportantes', this.get('datosImportantes'));

      console.log('DATOS IMPORTANTES', model.get('datosImportantes'));
      console.log(model);

      if (model.get('isValid')) {
        model.save().then(function (response) {
          // success
          self.transitionToRoute('pacientes').then(function () {
            Bodega.Notification.show('Exito', 'El paciente se ha actualizado.');
            Bodega.Utils.enableElement('button[type=submit]');
          });
        }, function (response) {
          //error
          Bodega.Utils.enableElement('button[type=submit]');
        });
      } else {
        console.log('modelo no valido');
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },
    cancel: function () {
      this.transitionToRoute('pacientes');
    },
    /*goEditFichaFonoaudiologia: function() {
      goEditFicha(this, 'fonoaudiologia');
    },
    goEditFichaOdontologia: function() {
      goEditFicha(this, 'odontologia');
    },
    goEditFichaCirugia: function() {
      goEditFicha(this, 'cirugia');
    },
    goEditFichaNutricion: function() {
      goEditFicha(this, 'nutricion');
    },*/
    activarNuevaCandidatura: function () {
      this.set('nuevaCandidatura', true);
    },
    cancelarCandidatura: function () {
      this.set('nuevaCandidatura', false);
    },
    agregarCandidatura: function () {
      var candidatura = this.store.createRecord('candidatura');
      candidatura.set('paciente', this.get('model'));
      candidatura.set('especialidad', this.get('especialidadSeleccionada'));
      candidatura.set('colaborador', this.get('colaboradorSeleccionado'));
      if (this.get('medianteSeleccionado').descripcion === 'Clínica') {
        candidatura.set('clinica', true);
        candidatura.set('fechaPosible', this.get('fechaPosible'));
      } else {
        candidatura.set('clinica', false);
        candidatura.set('fechaPosible', this.get('campanhaSeleccionada').get('fechaIncio'));
        candidatura.set('campanha', this.get('campanhaSeleccionada'));
      }

      console.log("Esta es la candidatura a guardar: ");
      console.log(candidatura);
      this.set('nuevaCandidatura', false);
      this.get('model').get('candidaturas').pushObject(candidatura);
    },
    eliminarCandidatura: function (candidatura) {
      this.get('model').get('candidaturas').removeObject(candidatura);
    }
  }
});

Bodega.PacienteDeleteController = Ember.ObjectController.extend({
  actions: {
    deleteRecord: function () {
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function () {
        Bodega.Notification.show('Exito', 'El paciente se ha eliminado.');
        self.transitionToRoute('pacientes');
      });
    },

    cancel: function () {
      $('body').removeClass('modal-open');
      this.transitionToRoute('pacientes');
    }
  }
});
