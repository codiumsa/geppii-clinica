Bodega.DepositosIndexController = Ember.ArrayController.extend(Bodega.mixins.Pageable, 
  Bodega.mixins.Filterable,  {
  resource:  'deposito'
});

Bodega.DepositosNewController = Ember.ObjectController.extend({
  
  formTitle: 'Nuevo Depósito',

  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;

      Bodega.Utils.disableElement('button[type=submit]');

      if(model.get('isValid')) {
        model.save().then(function(response) {
          // success
          self.transitionToRoute('depositos');
          Bodega.Notification.show('Éxito', 'El depósito se ha guardado.');
          Bodega.Utils.enableElement('button[type=submit]');
        }, function(response){
          Bodega.Utils.enableElement('button[type=submit]');
        });
      }else{
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },

    cancel: function() {
      var model = this.get('model');
      this.transitionToRoute('depositos');
    }
  }
});

Bodega.DepositoEditController = Ember.ObjectController.extend({

  formTitle: 'Editar Depósito',
  
  actions: {
    save: function() {
      var model = this.get('model');    
      var self = this;
      Bodega.Utils.disableElement('button[type=submit]');

      if(model.get('isValid')) {
        model.save().then(function(response) {
          //success
          self.transitionToRoute('depositos');
          Bodega.Notification.show('Éxito', 'El depósito se ha actualizado.');
          Bodega.Utils.enableElement('button[type=submit]');
        }, function(response) {
          Bodega.Utils.enableElement('button[type=submit]');
        });
      }else{
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },

    cancel: function() {
      this.transitionToRoute('depositos');
    }
  }
});

Bodega.DepositoDeleteController = Ember.ObjectController.extend({
  actions: {
    deleteRecord: function() {
			$('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        self.transitionToRoute('depositos');
        Bodega.Notification.show('Éxito', 'El depósito se ha eliminado.');

      }, function(){
        Bodega.Notification.show('Error', 'No se pudo eliminar el depósito.', Bodega.Notification.ERROR_MSG);
      });
    },

    cancel: function() {
			$('body').removeClass('modal-open');
      this.transitionToRoute('depositos');
    }
  }
});