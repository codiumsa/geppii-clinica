Bodega.CategoriasNewController = Ember.ObjectController.extend({

  formTitle: 'Nueva Categoria',

  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      Bodega.Utils.disableElement('button[type=submit]');
      if(model.get('isValid')) {
        model.save().then(function(response) {
          // success
          self.transitionToRoute('categorias').then(function() {
            Bodega.Notification.show('Éxito', 'La categoría se ha creado.');
            Bodega.Utils.enableElement('button[type=submit]');
          });
        }, function(response) {
            Bodega.Notification.show('Error', 'La categoría no se pudo crear', 'error');
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
      this.transitionToRoute('categorias');
    }
  }
});

Bodega.CategoriaEditController = Ember.ObjectController.extend({

  formTitle: 'Editar Categoria',
  
  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      Bodega.Utils.disableElement('button[type=submit]');
      model.save().then(function(response) {
        //success
        Bodega.Notification.show('Éxito', 'La categoría se ha modificado.');
        Bodega.Utils.enableElement('button[type=submit]');
        self.transitionToRoute('categorias');
      }, function(response) {
          Bodega.Notification.show('Error', 'La categoría no se pudo crear', 'error');
          Bodega.Utils.enableElement('button[type=submit]');
          model.transitionTo('uncommitted');
          //model.rollback();
      });
    },

    cancel: function() {
      this.transitionToRoute('categorias');
    }
  }
});

Bodega.CategoriaDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
			$('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        Bodega.Notification.show('Éxito', 'La categoría se ha eliminado.');
        Bodega.Utils.enableElement('button[type=submit]');
        self.transitionToRoute('categorias');
     }, function(response) {
        //error
        Bodega.Notification.show('Éxito', 'La categoría se ha eliminado.','error');
        Bodega.Utils.enableElement('button[type=submit]');
        model.transitionTo('uncommitted');
      });
    },

    cancel: function() {
			$('body').removeClass('modal-open');
      this.transitionToRoute('categorias');
    }
  }
});

Bodega.CategoriasIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable, Bodega.mixins.Filterable, {
  resource:  'categoria'
});
