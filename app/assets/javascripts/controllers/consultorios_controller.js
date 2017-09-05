Bodega.ConsultoriosIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable,
  Bodega.mixins.Filterable, {
  resource:  'consultorio'
});

Bodega.ConsultoriosNewController = Ember.ObjectController.extend({

  formTitle: 'Nuevo Consultorio',

  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      var errors = model.get('errors');


      this.set('especialidad',this.get('especialidadSeleccionada'));

      if (model.get('isValid')) {
        Bodega.Utils.disableElement('button[type=submit]');
        model.save().then(function(response) {
          //success

          self.transitionToRoute('consultorios');
        }, function(response) {
          Bodega.Notification.show('Error', 'No se pudo crear el consultorio.', Bodega.Notification.ERROR_MSG);
          Bodega.Utils.enableElement('button[type=submit]');
        });
      } else {
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },

    cancel: function() {
      var model = this.get('model');
      model.deleteRecord();
      this.transitionToRoute('consultorios');
    }
  }
});

Bodega.ConsultorioEditController = Ember.ObjectController.extend({

  formTitle: 'Editar Consultorio',

  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      var errors = model.get('errors');

      this.set('especialidad',this.get('especialidadSeleccionada'));

      if (model.get('isValid')) {
        Bodega.Utils.disableElement('button[type=submit]');
        model.save().then(function(response) {
          //success
          self.transitionToRoute('consultorios');
        }, function(response) {
           Bodega.Utils.enableElement('button[type=submit]');
        });
      } else {
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },

    cancel: function() {
      this.transitionToRoute('consultorios');
    }
  }
});

Bodega.ConsultorioDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
			$('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        self.transitionToRoute('consultorios');
      });
    },

    cancel: function() {
			$('body').removeClass('modal-open');
      this.transitionToRoute('consultorios');
    }
  }
});
