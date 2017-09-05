Bodega.TipoContactosIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable,
  Bodega.mixins.Filterable, {
  resource:  'tipoContacto',
    staticFilters: {
    by_activo: true
  },
});

Bodega.TipoContactosNewController = Ember.ObjectController.extend({

  formTitle: 'Nueva Oportunidad',

  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;


      if(model.get('isValid')) {
        Bodega.Utils.disableElement('.btn');
        model.save().then(function(response) {
          //success
          self.transitionToRoute('tipoContactos').then(function () {
            Bodega.Notification.show('Éxito', 'Tipo Contacto con Sponsor creado');
            Bodega.Utils.enableElement('.btn');
          });
        }, function(response) {
          //error
          Bodega.Utils.enableElement('.btn');
        });
      }
    },

    cancel: function() {
      var model = this.get('model');
      model.deleteRecord();
      this.transitionToRoute('tipoContactos');
    }
  }
});

Bodega.TipoContactoEditController = Ember.ObjectController.extend({

  formTitle: 'Editar Oportunidad',

  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;


      if(model.get('isValid')) {
        Bodega.Utils.disableElement('.btn');
        model.save().then(function(response) {
          //success
          self.transitionToRoute('tipoContactos').then(function () {
            Bodega.Notification.show('Éxito', 'Tipo Contacto con Sponsor actualizado');
            Bodega.Utils.enableElement('.btn');
          });
        }, function(response) {
          //error
          //model.transitionTo('uncommited');
          Bodega.Utils.enableElement('.btn');
        });
      }
    },

    cancel: function() {
      this.transitionToRoute('tipoContactos');
    }
  }
});

Bodega.TipoContactoDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        self.transitionToRoute('tipoContactos');
      });
    },

    cancel: function() {
			$('body').removeClass('modal-open');
      this.transitionToRoute('tipoContactos');
    }
  }
});
