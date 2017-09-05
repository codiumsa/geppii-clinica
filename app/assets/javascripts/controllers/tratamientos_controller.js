Bodega.TratamientosIndexController = Ember.ArrayController.extend(Bodega.mixins.Pageable, Bodega.mixins.Filterable, {
  resource: 'tratamiento'
});

Bodega.TratamientosNewController = Ember.ObjectController.extend({

  formTitle: 'Nuevo Tratamiento',
  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      Bodega.Utils.disableElement('button[type=submit]');

      var especialidadSeleccionada = this.get('especialidadSeleccionada');
      model.set('especialidad', especialidadSeleccionada);

      model.save().then(function(response) {
        // success
        self.transitionToRoute('tratamientos').then(function() {
          Bodega.Notification.show('Exito', 'El tratamiento se ha creado.');
          Bodega.Utils.enableElement('button[type=submit]');
        });
      }, function(response) {
        // error
        Bodega.Notification.show('Error', 'No se pudo crear el tratamiento.',
          Bodega.Notification.ERROR_MSG);
        Bodega.Utils.enableElement('button[type=submit]');
      });
    },

    cancel: function() {
      this.transitionToRoute('tratamientos');
    }
  }
});

Bodega.TratamientoEditController = Ember.ObjectController.extend({

  formTitle: 'Editar Tratamiento',
  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;

      var especialidadSeleccionada = this.get('especialidadSeleccionada');
      model.set('especialidad', especialidadSeleccionada);
      Bodega.Utils.disableElement('button[type=submit]');

      model.save().then(function(response) {
        //success
        self.transitionToRoute('tratamientos').then(function() {
          Bodega.Notification.show('Exito', 'El tratamiento se ha actualizado.');
          Bodega.Utils.enableElement('button[type=submit]');
        });
      }, function(response) {
        //error
        Bodega.Notification.show('Error', 'No se pudo actualizar el tratamiento.', Bodega.Notification.ERROR_MSG);
        Bodega.Utils.enableElement('button[type=submit]');
      });
    },

    cancel: function() {
      this.transitionToRoute('tratamientos');
    }
  }
});

Bodega.TratamientoDeleteController = Ember.ObjectController.extend({
  actions: {
    deleteRecord: function() {
      $('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      Bodega.Utils.disableElement('button[type=submit]');
      model.save().then(function() {
        self.transitionToRoute('tratamientos').then(function() {
          Bodega.Notification.show('Exito', 'El tratamiento se ha eliminado.');
          Bodega.Utils.enableElement('button[type=submit]');
        });
      }, function(response) {
        Bodega.Notification.show('Error', 'No se pudo borrar el tratamiento.', Bodega.Notification.ERROR_MSG);
        Bodega.Utils.enableElement('button[type=submit]');
      });
    },

    cancel: function() {
      $('body').removeClass('modal-open');
      this.transitionToRoute('tratamientos');
    }
  }
});