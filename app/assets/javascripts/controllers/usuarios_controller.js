Bodega.UsuariosIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable,
  Bodega.mixins.Filterable, {
    resource: 'usuario',
    perPage: 15
  });

//*****************************BASE Controller******************************************
Bodega.UsuariosBaseController = Ember.ObjectController.extend({

});



Bodega.UsuariosNewController = Bodega.UsuariosBaseController.extend({

  formTitle: 'Nuevo Usuario',

  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      Bodega.Utils.disableElement('button[type=submit]');

      if (model.get('isValid')) {
        model.save().then(function(response) {
          // success
          self.set('model', response);
          self.transitionToRoute('usuarios').then(function() {
            Bodega.Notification.show('Exito', 'El usuario se ha guardado.');
            Bodega.Utils.enableElement('button[type=submit]');
          });
        }, function(response) {
          Bodega.Notification.show('Error', 'No se pudo crear el usuario.', Bodega.Notification.ERROR_MSG);
          Bodega.Utils.enableElement('button[type=submit]');
        });
      } else {
        Bodega.Utils.enableElement('button[type=submit]');
      }



    },

    cancel: function() {
      var model = this.get('model');
      model.deleteRecord();
      this.transitionToRoute('usuarios');
    }
  }
});

Bodega.UsuarioEditController = Bodega.UsuariosBaseController.extend({

  formTitle: 'Editar Usuario',

  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      Bodega.Utils.disableElement('button[type=submit]');

      if (model.get('isValid')) {
        model.save().then(function(response) {
          self.set('model', response);
          if (!($.inArray('FE_put_usuarios', self.get('session.permisos').split(",")) > -1)) {
            console.log("No tiene el permiso de editar usuarios.. se permanece en la vista actual");
            Bodega.Notification.show('Exito', 'El usuario se ha guardado.');
            Bodega.Utils.enableElement('button[type=submit]');
          } else {
            self.transitionToRoute('usuarios').then(function() {
              Bodega.Notification.show('Exito', 'El usuario se ha actualizado.');
              Bodega.Utils.enableElement('button[type=submit]');
            });
          }
        }, function(response) {

          Bodega.Notification.show('Error', 'No se pudo actualizar el usuario.', Bodega.Notification.ERROR_MSG);
          Bodega.Utils.enableElement('button[type=submit]');
        });
      } else {
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },

    cancel: function() {
      this.transitionToRoute('usuarios');
    }
  }
});

Bodega.UsuarioDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
      $('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      Bodega.Utils.disableElement('button[type=submit]');
      model.deleteRecord();
      model.save().then(function() {
        self.transitionToRoute('usuarios').then(function() {
          Bodega.Notification.show('Exito', 'El usuario se ha eliminado.');
          Bodega.Utils.enableElement('button[type=submit]');
        });
      }, function(response) {

        Bodega.Notification.show('Error', 'No se pudo borrar el usuario.', Bodega.Notification.ERROR_MSG);
        Bodega.Utils.enableElement('button[type=submit]');
      });
    },

    cancel: function() {
      $('body').removeClass('modal-open');
      this.transitionToRoute('usuarios');
    }
  }
});