Bodega.TipoColaboradoresNewController = Ember.ObjectController.extend({

  formTitle: 'Nuevo Tipo Voluntario',

  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      Bodega.Utils.disableElement('button[type=submit]');
      if(model.get('isValid')) {
        model.save().then(function(response) {
          // success
          self.transitionToRoute('tipo_colaboradores').then(function() {
            Bodega.Notification.show('Éxito', 'El tipo de colaborador se ha creado.');
            Bodega.Utils.enableElement('button[type=submit]');
          });
        }, function(response) {
            Bodega.Notification.show('Error', 'El tipo de colaborador no se pudo crear', 'error');
            Bodega.Utils.enableElement('button[type=submit]');
            model.transitionTo('uncommitted');
            //model.rollback();
        });
      }else{
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },

    cancel: function() {
      var model = this.get('model');
      model.deleteRecord();
      this.transitionToRoute('tipo_colaboradores');
    }
  }
});

Bodega.TipoColaboradorEditController = Ember.ObjectController.extend({

  formTitle: 'Editar Tipo Voluntario',
  
  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      Bodega.Utils.disableElement('button[type=submit]');
      model.save().then(function(response) {
        //success
        Bodega.Notification.show('Éxito', 'El tipo de colaborador se ha modificado.');
        Bodega.Utils.enableElement('button[type=submit]');
        self.transitionToRoute('tipo_colaboradores');
      }, function(response) {
          Bodega.Notification.show('Error', 'El tipo de colaborador no se pudo crear', 'error');
          Bodega.Utils.enableElement('button[type=submit]');
          model.transitionTo('uncommitted');
          //model.rollback();
      });
    },

    cancel: function() {
      this.transitionToRoute('tipo_colaboradores');
    }
  }
});

Bodega.TipoColaboradorDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
      $('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        Bodega.Notification.show('Éxito', 'El tipo de colaborador se ha eliminado.');
        Bodega.Utils.enableElement('button[type=submit]');
        self.transitionToRoute('tipo_colaboradores');
     }, function(response) {
        //error
        Bodega.Notification.show('Éxito', 'El tipo de colaborador se ha eliminado.','error');
        Bodega.Utils.enableElement('button[type=submit]');
        model.transitionTo('uncommitted');
      });
    },

    cancel: function() {
      $('body').removeClass('modal-open');
      this.transitionToRoute('tipo_colaboradores');
    }
  }
});

Bodega.TipoColaboradoresIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable, Bodega.mixins.Filterable, {
  resource:  'tipo_colaborador',
  formTitle: 'Tipos Voluntarios'
});
