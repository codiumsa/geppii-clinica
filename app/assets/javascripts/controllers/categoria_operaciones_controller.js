Bodega.CategoriaOperacionesIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable, 
  Bodega.mixins.Filterable, {
  resource:  'categoriaOperacion',
  staticFilters: {
   'con_tipo_operacion': true
  }
});


Bodega.CategoriaOperacionesNewController = Ember.ObjectController.extend({
  formTitle: 'Nueva Categoria de Operación',

  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      var tipoOperacionSeleccionada = this.get('tipoOperacionSeleccionada');
      if(tipoOperacionSeleccionada){
        model.set('tipoOperacion', tipoOperacionSeleccionada);
      }else{
        model.set('tipoOperacion', this.get('tipoOperacionDefault'));
      }

      Bodega.Utils.disableElement('.btn');
      //console.log("model cat cliente %o", model);
      model.save().then(function(response) {
        self.transitionToRoute('categoriaOperaciones').then(function () {
            Bodega.Notification.show('Éxito', 'Categoría de operación registrada');
            Bodega.Utils.enableElement('.btn');
          }); 
        
      }, function(response) {
        console.log(response);
         Bodega.Notification.show('Error', 'Ha ocurrido un error al guardar la categoría de operación', 
                                  Bodega.Notification.ERROR_MSG );
         // model.rollback();
        //  model.transitionTo('uncommitted');
          Bodega.Utils.enableElement('.btn');
          Bodega.Utils.enableElement('button[type=submit]');
      });
    
    },

    cancel: function() {
      var model = this.get('model');
      this.transitionToRoute('categoriaOperaciones');
    }
  }
});


Bodega.CategoriaOperacionEditController = Ember.ObjectController.extend({
  formTitle: 'Editar CategoriaOperacion',
  
  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      var tipoOperacionSeleccionada = this.get('tipoOperacionSeleccionada');
      var tipoOperacionDefault = this.get('tipoOperacionDefault');
      console.log('SELECCIONADO: ');
      console.log(tipoOperacionSeleccionada);
      console.log('DEFAULT: ');
      console.log(tipoOperacionDefault);
      
      if(tipoOperacionSeleccionada){
        model.set('tipoOperacion', tipoOperacionSeleccionada);
      }else{
        model.set('tipoOperacion', tipoOperacionDefault);
      }
      Bodega.Utils.disableElement('.btn');
      model.save().then(function(response) {
        self.transitionToRoute('categoriaOperaciones').then(function () {
            Bodega.Notification.show('Éxito', 'CategoriaOperacion actualizada');
            Bodega.Utils.enableElement('.btn');
          }); 
        
      }, function(response) {
          Bodega.Notification.show('Error', 'Ha ocurrido un error al editar la categoría de operación', 
                                  Bodega.Notification.ERROR_MSG );
          //model.rollback();
          model.transitionTo('uncommitted');
          Bodega.Utils.enableElement('.btn');
      });
    
    },

    cancel: function() {
      var model = this.get('model');
      this.transitionToRoute('categoriaOperaciones');
    }
  }
});

Bodega.CategoriaOperacionDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
			$('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        self.transitionToRoute('categoriaOperaciones').then(function () {
          Bodega.Notification.show('Exito', 'la categoría de operación se ha eliminado.');
          Bodega.Utils.enableElement('button[type=submit]');
        });
      }, function(response) {

        Bodega.Notification.show('Error', 'No se pudo borrar la categoría de operación.', Bodega.Notification.ERROR_MSG);
        Bodega.Utils.enableElement('button[type=submit]');
        //model.rollback();
        model.transitionTo('uncommitted');
      });
    },

    cancel: function() {
			$('body').removeClass('modal-open');
      this.transitionToRoute('categoriaOperaciones');
    }
  }
});