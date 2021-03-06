Bodega.CategoriaClientesIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable, 
  Bodega.mixins.Filterable, {
  resource:  'categoriaCliente',
  perPage:  15,
 // staticFilters: {
  //  ignorar_cliente_default: true
  //}
});


Bodega.CategoriaClientesNewController = Ember.ObjectController.extend({
  formTitle: 'Nueva Categoria',

  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;

      Bodega.Utils.disableElement('.btn');
      //console.log("model cat cliente %o", model);
      model.save().then(function(response) {
        self.transitionToRoute('categoriaClientes').then(function () {
            Bodega.Notification.show('Éxito', 'Categoria Cliente registrada');
            Bodega.Utils.enableElement('.btn');
          }); 
        
      }, function(response) {
        console.log(response);
         Bodega.Notification.show('Error', 'Ha ocurrido un error al guardar la categoría cliente', 
                                  Bodega.Notification.ERROR_MSG );
         // model.rollback();
        //  model.transitionTo('uncommitted');
          Bodega.Utils.enableElement('.btn');
          Bodega.Utils.enableElement('button[type=submit]');
      });
    
    },

    cancel: function() {
      var model = this.get('model');
      this.transitionToRoute('categoriaClientes');
    }
  }
});


Bodega.CategoriaClienteEditController = Ember.ObjectController.extend({
  formTitle: 'Editar Categoria',
  
  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      Bodega.Utils.disableElement('.btn');
      model.save().then(function(response) {
        self.transitionToRoute('categoriaClientes').then(function () {
            Bodega.Notification.show('Éxito', 'Categoria Cliente actualizada');
            Bodega.Utils.enableElement('.btn');
          }); 
        
      }, function(response) {
          Bodega.Notification.show('Error', 'Ha ocurrido un error al editar la categoria cliente', 
                                  Bodega.Notification.ERROR_MSG );
          //model.rollback();
          model.transitionTo('uncommitted');
          Bodega.Utils.enableElement('.btn');
      });
    
    },

    cancel: function() {
      var model = this.get('model');
      this.transitionToRoute('categoriaClientes');
    }
  }
});

Bodega.CategoriaClienteDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
			$('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        self.transitionToRoute('categoriaClientes').then(function () {
          Bodega.Notification.show('Exito', 'La categoria se ha eliminado.');
          Bodega.Utils.enableElement('button[type=submit]');
        });
      }, function(response) {

        Bodega.Notification.show('Error', 'No se pudo borrar la categoria.', Bodega.Notification.ERROR_MSG);
        Bodega.Utils.enableElement('button[type=submit]');
        //model.rollback();
        model.transitionTo('uncommitted');
      });
    },

    cancel: function() {
			$('body').removeClass('modal-open');
      this.transitionToRoute('categoriaClientes');
    }
  }
});