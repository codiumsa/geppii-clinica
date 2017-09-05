Bodega.CalificacionesIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable, 
  Bodega.mixins.Filterable, {
  resource:  'calificacion',
 // staticFilters: {
  //  ignorar_cliente_default: true
  //}
});


Bodega.CalificacionesNewController = Ember.ObjectController.extend({
  formTitle: 'Nueva Calificacion de Cliente',

  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;

      Bodega.Utils.disableElement('.btn');
      if(model.get('isValid')) {
        model.save().then(function(response) {
          self.transitionToRoute('calificaciones').then(function () {
              Bodega.Notification.show('Éxito', 'Calificacion de Cliente registrada');
              Bodega.Utils.enableElement('.btn');
            }); 
          
        }, function(response) {
          console.log(response);
          var errores = response.errors.base;
          if(errores){
            for(var i=0; i<errores.length; i++){
              Bodega.Notification.show('Error', errores[i], Bodega.Notification.ERROR_MSG);
            }
          }else{
            Bodega.Notification.show('Error', 'No se pudo guardar la calificacion.', Bodega.Notification.ERROR_MSG);
          }
          Bodega.Utils.enableElement('.btn');
          Bodega.Utils.enableElement('button[type=submit]');
        });
      }else{
        Bodega.Utils.enableElement('button[type=submit]');
      }
    
    },

    cancel: function() {
      var model = this.get('model');
      this.transitionToRoute('calificaciones');
    }
  }
});


Bodega.CalificacionEditController = Ember.ObjectController.extend({
  formTitle: 'Editar Calificacion de Cliente',
  
  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      Bodega.Utils.disableElement('.btn');
      if(model.get('isValid')) {
        model.save().then(function(response) {
          self.transitionToRoute('calificaciones').then(function () {
              Bodega.Notification.show('Éxito', 'Calificacion de Cliente actualizada');
              Bodega.Utils.enableElement('.btn');
            }); 
          
        }, function(response) {
          console.log(response);
          var errores = response.errors.base;
          if(errores){
            for(var i=0; i<errores.length; i++){
              Bodega.Notification.show('Error', errores[i], Bodega.Notification.ERROR_MSG);
            }
          }else{
            Bodega.Notification.show('Error', 'No se pudo guardar la calificacion.', Bodega.Notification.ERROR_MSG);
          }
          //model.rollback();
          //model.transitionTo('uncommitted');
          Bodega.Utils.enableElement('.btn');
        });
      }else{
        Bodega.Utils.enableElement('button[type=submit]'); 
      }
    },

    cancel: function() {
      var model = this.get('model');
      this.transitionToRoute('calificaciones');
    }
  }
});

Bodega.CalificacionDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        self.transitionToRoute('calificaciones').then(function () {
          Bodega.Notification.show('Exito', 'La calificacion se ha eliminado.');
          Bodega.Utils.enableElement('button[type=submit]');
        });
      }, function(response) {

        Bodega.Notification.show('Error', 'No se pudo borrar la calificacion.', Bodega.Notification.ERROR_MSG);
        Bodega.Utils.enableElement('button[type=submit]');
        model.rollback();
        model.transitionTo('uncommitted');
      });
    },

    cancel: function() {
			$('body').removeClass('modal-open');
      this.transitionToRoute('calificaciones');
    }
  }
});