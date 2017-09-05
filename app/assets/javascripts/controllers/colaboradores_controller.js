Bodega.ColaboradoresIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable,
  Bodega.mixins.Filterable, {
    resource: 'colaborador',
    hasSearchForm: true,
    searchFormTpl: 'colaboradores/searchform',
    searchFormModal: '#colaboradorSearchForm',
    perPage: 15,
    staticFilters: {
      by_activo: true
    },

    filterToParam: {
      by_ciRuc: 'by_ciRuc',
      by_razon_social: 'by_razon_social',
      by_sexo: 'by_sexo',
      by_tipo_persona: 'by_tipo_persona',
    },

    clearSearchForm: function() {
      var self = this;
      Ember.keys(self.filterToParam).forEach(function(f) {
        self.set(f, '');
      });
    },

    actions: {
      criteriaSearch: function() {

        var self = this;
        var ciRuc = this.get('ciRuc');
        var nroColaborador = this.get('nroColaborador');
        var filters = this.get('filters');

        Ember.keys(self.filterToParam).forEach(function(f) {
          var value = self.get(f);
          if (value) {
            filters[self.filterToParam[f]] = value;
          }
        });
        this.set('filters', filters);
        console.log('Seteando filtros: ', this.get('filters'));
        this.store.find('colaborador', filters).then(function(model) {
          self.set('model', model);
        });
      },

      goEditColaborador: function(id) {
        var colaborador = this.store.find('colaborador', id);
        this.transitionTo("colaborador.edit", colaborador);
      }
    }
  });

Bodega.ColaboradorBaseController = Ember.ObjectController.extend({

  esComerciante: false,
  esJubilado: false,
  esEmpleador: false,
  feedback: {},
  isCiudadLoaded: false,
  isEdit: false,
  vinculoFamiliarSeleccionado: null,
  isNotMedico: Ember.computed.not('tipoColaboradorSeleccionado.tieneLicencia'),

  tipoColaboradorSelect: function() {
    tipoColaboradorSeleccionado = this.get('tipoColaboradorSeleccionado');
    console.log(tipoColaboradorSeleccionado);
    if (tipoColaboradorSeleccionado != null && tipoColaboradorSeleccionado.get('nombre') === "Club Estudiantil") {
      this.set('esClub', true);
    } else {
      this.set('esClub', false);
    }
  }.observes('tipoColaboradorSeleccionado'),

  actions: {
    loadColaborador: function() {
      console.log('LOAD COLABORADOR IF EXIST ');
      var ruc = this.get('persona.ciRuc');
      var self = this;
      var model = self.get('model');
      if (ruc) {
        var personas = self.store.find('persona', { 'by_ciRuc': ruc });

        personas.then(function() {
          var persona = personas.objectAt(0);
          if (persona) {
            var colaboradores = self.store.find('colaborador', { 'by_persona_id': persona.get('id') });
            colaboradores.then(function() {
              var colaborador = colaboradores.objectAt(0);
              if (colaborador) {
                console.log('Ir a edición de colaborador con CI: ', persona.get('ci_ruc'));
                self.set('habilitaTipoPersona',false);
                self.transitionToRoute("colaborador.edit", colaborador);
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
          }else {

            self.set('habilitaTipoPersona',true);
          }
        });
      }
    },

    loadCiudad: function() {

      var self = this;
      var ciudadSeleccionada = this.get('ciudadSeleccionada');
      var model = this.get('model');
      var persona = model.get('persona');

      if (ciudadSeleccionada) {
        var ciudades = this.store.find('ciudad', { by_codigo: ciudadSeleccionada.get('codigo') });
        ciudades.then(function() {
          var ciudad = ciudades.objectAt(0);

          if (ciudad) {
            persona.set('ciudad', ciudad);
          }
        });
      }
    }.observes('ciudadSeleccionada'),

    // setTipoPersona: function(){
    //   console.log();
    //   if (this.get('habilitaTipoPersona')) {
    //     model.set('persona.tipoPersona',this.get('tipoPersonaSeleccionada'));
    //     console.log('entrosettipopersona');
    //   }
    // }.observes('tipoPersonaSeleccionada'),




    // nombreORazonSocial: function() {
    //   console.log('holaa');
    //   var tipoPersona = this.get('persona.tipoPersona');
    //
    //   if (tipoPersona === 'Física') {
    //     this.set('mostrarRazonSocial', false);
    //   } else if (tipoPersona === 'Jurídica') {
    //     this.set('mostrarRazonSocial', true);
    //   }
    //
    // }.observes('persona.tipoPersona'),

    cancel: function() {
      var model = this.get('model');
      this.transitionToRoute('colaboradores');
    },

    loadFromSearchWidget: function() {
      //console.log("ColaboradoresBaseController->loadFromSearchWidget");
      if (!this.get('agregandoDetalle')) {
        //console.log("ColaboradoresBaseController->loadFromSearchWidget agregandoDetalle false");
        var campanhaSeleccionada = this.get('campanhaSeleccionadaSW');
        //console.log(campanhaSeleccionada);
        if (campanhaSeleccionada && campanhaSeleccionada.get('id') !== null) {
          this.loadCampanha();
        }
      }
    }.observes('campanhaSeleccionadaSW'),

    agregarDetalle: function() {
      //console.log("Agregando detalle");
      var campanha = this.get('campanhaSeleccionadaSW');
      if (!campanha) {
        Bodega.Notification.show('Error', 'Ingrese una campaña', Bodega.Notification.ERROR_MSG);
        return;
      }
      var detalle = this.get('campanhaNueva');
      var self = this;
      var campanhasColaboradores = this.get('campanhas');
      if (campanhasColaboradores) {
        cantidadcampanhas = campanhasColaboradores.content.length;
      } else {
        console.log("No existen los campanhas!!");
        return;
      }
      this.set('agregandoDetalle', true);
      console.log("campanha a agregar",campanha);
      detalle.set('campanha', campanha);
      campanhasColaboradores.addRecord(detalle);
      this.set('agregandoDetalle', false);
      this.send('clearCampanha');
      //console.log('Campanha agregada, lista: ', this.get('campanhas'));

    },

    loadCampanha: function() {
      //console.log('ColaboradoresBaseController->loadcampanha');
      //console.log('campanhaSeleccionadaSW', this.get('campanhaSeleccionadaSW'));
      var model = this.get('model');
      var detalle = this.get('campanhaNueva');
      if (this.get('campanhaSeleccionadaSW')) {
        detalle.set('campanha', this.get('campanhaSeleccionadaSW'));
        $("#observaciones").focus();
      } else {
        $("#campanha").focus();
      }
    },

    clearCampanha: function() {
      //console.log("ColaboradoressBaseController->clearCampanha: " + !this.get('agregandoDetalle'));
      console.log('AGREGANDO DETALLE:', this.get('agregandoDetalle'));
      if (!this.get('agregandoDetalle')) {
        console.log('Limpiando searchinput...');
        this.set('campanhaNueva', this.store.createRecord('campanhaColaborador'));
        this.set('descripcionSW', null);
        this.set('descripcionSW', '');
        this.set('campanhaSeleccionada', null);
        this.set('campanhaSeleccionadaSW', null);
      }
      $("#campanha").focus();
      this.set('count', 0);
    },

    contarEnters: function() {
      //console.log("VentasBaseController->action->contarEnters");
      var count = this.get('count');
      if (count === undefined) {
        count = 0;
        this.set('count', count);
      }

      count = count + 1;

      if (count >= this.get('enters')) {
        this.set('count', 0);
        this.send('agregarDetalle');
      } else {
        this.set('count', count);
      }
    },

    resetCount: function() {
      //console.log("VentasBaseController->action->resetCount");
      var count = this.get('codigoBarra');
      if (count === "") {
        this.set('count', 0);
      }
    }.observes('campanha'),
    borrarDetalle: function(detalle) {
      this.get('campanhas').removeRecord(detalle);
    },
    save: function() {
      var model = this.get('model');
      var self = this;

      var tipoColaborador = this.get('tipoColaboradorSeleccionado');
      var especialidad = this.get('especialidadSeleccionada');
      var ciudad = this.get('ciudadDefault');
      var campanhas = self.get('campanhas');

      if (!tipoColaborador.get('tieneLicencia')) {
        if (tipoColaborador.get('nombre') == 'Club Estudiantil') {
          model.set('licencia',null);
          model.set('comisionamiento',null);
          model.set('acreditado',null);
          model.set('tipo',null);
          model.set('bls',null);
          model.set('pals',null);
          model.set('vencimientoRegistroMedico',null);
          model.set('titulo',null);
          model.set('vencimientoBls',null);
          model.set('vencimientoPals',null);
          model.set('otros',null);
          model.set('institucion',null);
          model.set('talleRemera',null);
          model.set('lugarTrabajo_1',null);
          model.set('lugarTrabajo_2',null);
          model.set('lugarTrabajo_3',null);
          model.set('horarioTrabajo_3',null);
          model.set('horarioTrabajo_2',null);
          model.set('horarioTrabajo_1',null);
        }else {
          console.log('entraelse');
          model.set('licencia',null);
          model.set('vencimientoRegistroMedico',null);
          model.set('lugarTrabajo_1',null);
          model.set('lugarTrabajo_2',null);
          model.set('lugarTrabajo_3',null);
          model.set('horarioTrabajo_3',null);
          model.set('horarioTrabajo_2',null);
          model.set('horarioTrabajo_1',null);
          model.set('institucion',null);
          model.set('vencimientoBls',null);
          model.set('vencimientoPals',null);
          model.set('comisionamiento',null);
          model.set('nombreClub',null);
          model.set('nombreContactoClub',null);
          model.set('celularContactoClub',null);
          model.set('emailContactoClub',null);
          model.set('nombrePresidenteClub',null);
          model.set('celularPresidenteClub',null);
          model.set('correoPresidenteClub',null);

        }
      }else {
        model.set('bls',null);
        model.set('pals',null);
        model.set('nombreClub',null);
        model.set('nombreContactoClub',null);
        model.set('celularContactoClub',null);
        model.set('emailContactoClub',null);
        model.set('nombrePresidenteClub',null);
        model.set('celularPresidenteClub',null);
        model.set('correoPresidenteClub',null);
      }

      var campanhasColaboradores = model.get('campanhasColaboradores');
      campanhasColaboradores.then(function() {
        var campanhas = self.get('campanhas');
        campanhasColaboradores.clear();
        campanhas.forEach(function(u) {
          campanhasColaboradores.pushObject(u);
        });
      });

      console.log('Especialidad a setear: ', especialidad);
      if (!this.get('isNotMedico')) {
        if (especialidad) {
          this.set('model.especialidad', especialidad);
        }
      } else {
        this.set('model.especialidad', undefined);
      }
      if (tipoColaborador) {
        this.set('model.tipoColaborador', tipoColaborador);
      }
      if (ciudad) {
        this.set('model.persona.ciudad', ciudad);
      }

      Bodega.Utils.disableElement('button[type=submit]');

      var mostrarRazonSocial = this.get('persona.esTipoPersonaJuridica');
      if (!mostrarRazonSocial) {
        this.set('persona.razonSocial', this.get('persona.nombre') + ' ' + this.get('persona.apellido'));
      }

      // this.set('persona.tipoPersona', 'Física');

      if (model.get('isValid')) {
        console.log('Colaborador model isValid');
        model.save().then(function(response) {
          // success
          self.transitionToRoute('colaboradores').then(function() {
            Bodega.Notification.show('Exito', 'El colaborador se ha guardado.');
            Bodega.Utils.enableElement('button[type=submit]');
            self.set('feedback', {});
          });

        }, function(response) {
          // error
          self.set('feedback', response.errors);
          Bodega.Utils.enableElement('button[type=submit]');
        });
      } else {
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },
  }, //End Actions






});


Bodega.ColaboradoresNewController = Bodega.ColaboradorBaseController.extend({
  formTitle: 'Nuevo Voluntario',
});

Bodega.ColaboradorEditController = Bodega.ColaboradorBaseController.extend({

  formTitle: 'Editar Voluntario',
  isEdit: true,
  generarLegajo: function() {
    Bodega.Notification.show('Descarga.', 'El reporte se descargará.');
    var filters = {};
    var downloadParams = {};
    downloadParams.httpMethod = 'GET';
    filters.content_type = 'pdf';
    filters.report_type = 'reporte_legajo_colaborador';
    downloadParams.data = filters;
    var model = this.get('model');

    Bodega.$.fileDownload("/api/v1/colaboradores/" + model.get('id'), downloadParams).done(function() {
      Bodega.$.fileDownload("/adjuntos/" + model.get('id') + "/adjuntos-" + model.get('persona').get('ciRuc') + ".zip");
    });
  },

  cancel: function() {
    this.transitionToRoute('colaboradores');
  }
});

Bodega.ColaboradorDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        Bodega.Notification.show('Exito', 'El colaborador se ha eliminado.');
        self.transitionToRoute('colaboradores');
      });
    },

    cancel: function() {
      $('body').removeClass('modal-open');
      this.transitionToRoute('colaboradores');
    }
  }
});
