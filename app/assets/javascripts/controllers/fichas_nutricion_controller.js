Bodega.FichasNutricionBaseController = Bodega.ClinicaBaseController.extend({
  queryParams: ['paciente_id', 'consulta_id'],
  paciente_id: null,
  consulta_id: null,

  getNewModel: function(newField) {
    if (newField === 'controlNuevo') {
      return Ember.Object.create({ fecha: null, edad: null, peso: null, talla: null, pc: null, pe: null, te: null, imc: null, evolucion: null, eliminado: false });
    } else {
      return null;
    }
  },
  actions: {


    save: function() {
      var model = this.get('model');
      var self = this;
      Bodega.Utils.disableElement('button[type=submit]');
      model.set('datos', this.get('datosDto'));
      model.set('paciente', this.get('pacienteActual'));
      model.set('consultaId', this.get('consulta_id'));
      console.log('PACIENTE', model.get('paciente'));

      model.save().then(
        function(response) {
          self.store.find('paciente', { id: self.get('paciente_id') }).then(function(response) {
            if (self.get('consulta_id')) {
              self.transitionToRoute('consulta.edit', self.get('consulta_id')).then(function() {
                Bodega.Notification.show('Éxito', 'La ficha de nutrición se ha modificado.');
                Bodega.Utils.enableElement('button[type=submit]');
              });
            } else {
              self.transitionToRoute('paciente.edit', response.objectAt(0)).then(function() {
                Bodega.Notification.show('Éxito', 'La ficha de nutrición se ha modificado.');
                Bodega.Utils.enableElement('button[type=submit]');
              });
            }
          });
        },
        function(response) {
          Bodega.Notification.show('Error', 'La ficha de nutrición no se pudo crear', 'error');
          Bodega.Utils.enableElement('button[type=submit]');
          model.transitionTo('uncommitted');
        }
      );
    },

    cancel: function() {
      this.transitionToRoute('fichas_nutricion');
    }
  }
});

Bodega.FichasNutricionNewController = Bodega.FichasNutricionBaseController.extend({
  formTitle: 'Nueva Ficha Fonoaudiologia',
  listaControles: Ember.computed('datosDto.controles.@each.eliminado', function() {
    return this.get('datosDto.controles').filterBy('eliminado', false);
  }),
});

Bodega.FichaNutricionEditController = Bodega.FichasNutricionBaseController.extend({
  formTitle: 'Editar Ficha Nutrición',
  listaControles: Ember.computed('datosDto.controles.@each.eliminado', function() {
    return this.get('datosDto.controles').filterBy('eliminado', false);
  }),
});

Bodega.FichaNutricionDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
      $('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        Bodega.Notification.show('Éxito', 'La ficha de nutrición se ha eliminado.');
        Bodega.Utils.enableElement('button[type=submit]');
        self.transitionToRoute('fichasNutricion');
      }, function(response) {
        //error
        Bodega.Notification.show('Éxito', 'La ficha de nutrición se ha eliminado.', 'error');
        Bodega.Utils.enableElement('button[type=submit]');
        model.transitionTo('uncommitted');
      });
    },

    cancel: function() {
      $('body').removeClass('modal-open');
      this.transitionToRoute('fichas_nutricion');
    }
  }
});

Bodega.FichasNutricionIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable, Bodega.mixins.Filterable, {
    resource: 'fichaNutricion',
    perPage: 15
  }
);