Bodega.SponsorsIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable,
  Bodega.mixins.Filterable, {
    resource: 'sponsor',
    hasSearchForm: true,
    searchFormTpl: 'sponsors/searchform',
    searchFormModal: '#sponsorSearchForm',
    perPage: 9,
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
        var nroSponsor = this.get('nroSponsor');
        var filters = this.get('filters');
        Ember.keys(self.filterToParam).forEach(function(f) {
          var value = self.get(f);
          if (value) {
            filters[self.filterToParam[f]] = value;
          }
        });
        this.set('filters', filters);
        this.store.find('sponsor', filters).then(function(model) {
          self.set('model', model);
        });
      },
      goEditSponsor: function(id) {
        var sponsor = this.store.find('sponsor', id);
        this.transitionTo("sponsor.edit", sponsor);
      }
    }
  });
Bodega.SponsorBaseController = Ember.ObjectController.extend({
  esComerciante: false,
  esJubilado: false,
  esEmpleador: false,
  feedback: {},
  isCiudadLoaded: false,
  isEdit: false,
  vinculoFamiliarSeleccionado: null,
  loadSponsor: function() {
    console.log('LOAD SPONSOR IF EXIST ');
    var ruc = this.get('persona.ciRuc');
    var self = this;
    var model = self.get('model');
    if (ruc) {
      var personas = this.store.find('persona', { 'by_ciRuc': ruc });
      personas.then(function() {
        var persona = personas.objectAt(0);
        if (persona) {
            var sponsors = self.store.find('sponsor', { 'by_persona_id': persona.get('id') });
            sponsors.then(function() {
            var sponsor = sponsors.objectAt(0);
            if(sponsor){
              console.log('Ir a edición de colaborador con CI: ', persona.get('ciRuc'));
              self.transitionToRoute("sponsor.edit", sponsor);
            }
          });
          if (!persona.get('conyugue')) {
            persona.set('conyugue', self.store.createRecord('conyugue'));
          }
          model.set('persona', persona);
          model.set('idPersona', persona.get('id'));
          self.set('model', model);
        }
      });
    }
  },
  /*loadSponsor: function() {
    console.log('LOAD SPONSOR IF EXIST ');
    var ruc = this.get('persona.ciRuc');
    var self = this;
    var model = self.get('model');
    if (ruc) {
      var personas = this.store.find('persona', {'by_ciRuc': ruc});
      personas.then(function() {
        var persona = personas.objectAt(0);
        if (persona) {
          if (!persona.get('conyugue')){
            persona.set('conyugue', self.store.createRecord('conyugue'));
          }
          console.log('Cargando persona....', persona);
          self.get('model').set('persona', persona);
          self.get('model').set('idPersona', persona.get('id'));
          console.log(self.get('model'));
        }
      });
    }
  },*/
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
  nombreORazonSocial: function() {
    var tipoPersona = this.get('persona.tipoPersona');
    if (tipoPersona === 'Física') {
      this.set('mostrarRazonSocial', false);
    } else if (tipoPersona === 'Jurídica') {
      this.set('mostrarRazonSocial', true);
    }
  }.observes('persona.tipoPersona'),
});
Bodega.SponsorsNewController = Bodega.SponsorBaseController.extend({
  formTitle: 'Nuevo Patrocinador',
  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      Bodega.Utils.disableElement('button[type=submit]');
      var mostrarRazonSocial = this.get('mostrarRazonSocial');
      if (!mostrarRazonSocial) {
        this.set('persona.razonSocial', this.get('persona.nombre') + ' ' + this.get('persona.apellido'));
      }
      if (model.get('isValid')) {
        console.log('Sponsor model isValid');
        model.save().then(function(response) {
          // success
          self.transitionToRoute('sponsors').then(function() {
            Bodega.Notification.show('Exito', 'El sponsor se ha guardado.');
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
    cancel: function() {
      var model = this.get('model');
      this.transitionToRoute('sponsors');
    }
  }
});
Bodega.SponsorEditController = Bodega.SponsorBaseController.extend({
  formTitle: 'Editar Patrocinador',
  isEdit: true,
  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      Bodega.Utils.disableElement('button[type=submit]');
      var mostrarRazonSocial = this.get('mostrarRazonSocial');
      if (!mostrarRazonSocial) {
        this.set('persona.razonSocial', this.get('persona.nombre') + ' ' + this.get('persona.apellido'));
      }
      if (model.get('isValid')) {
        model.save().then(function(response) {
          // success
          self.transitionToRoute('sponsors').then(function() {
            Bodega.Notification.show('Exito', 'El sponsor se ha actualizado.');
            Bodega.Utils.enableElement('button[type=submit]');
          });
        }, function(response) {
          //error
          Bodega.Utils.enableElement('button[type=submit]');
        });
      } else {
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },
    generarLegajo: function() {
      Bodega.Notification.show('Descarga.', 'El reporte se descargará.');
      var filters = {};
      var downloadParams = {};
      downloadParams.httpMethod = 'GET';
      filters.content_type = 'pdf';
      filters.report_type = 'reporte_legajo_sponsor';
      downloadParams.data = filters;
      var model = this.get('model');
      Bodega.$.fileDownload("/api/v1/sponsors/" + model.get('id'), downloadParams).done(function() {
        Bodega.$.fileDownload("/adjuntos/" + model.get('id') + "/adjuntos-" + model.get('persona').get('ciRuc') + ".zip");
      });
    },
    cancel: function() {
      this.transitionToRoute('sponsors');
    }
  }
});
Bodega.SponsorDeleteController = Ember.ObjectController.extend({
  actions: {
    deleteRecord: function() {
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        Bodega.Notification.show('Exito', 'El patrocinador se ha eliminado.');
        self.transitionToRoute('sponsors');
      });
    },
    cancel: function() {
      $('body').removeClass('modal-open');
      this.transitionToRoute('sponsors');
    }
  }
});
