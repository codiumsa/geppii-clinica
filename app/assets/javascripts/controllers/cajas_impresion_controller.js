Bodega.CajasImpresionIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable, 
  Bodega.mixins.Filterable, {
  resource:  'cajaImpresion'
});

Bodega.CajasImpresionNewController = Ember.ObjectController.extend({


  


  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      var nombre = this.get('nombre');
      //model.set('tipoCaja', tipo.id);
      model.set('nombre', nombre);
      
      model.save().then(function(response) {
        // success
        self.transitionToRoute('cajasImpresion');
      }, function(response){
        // error
      });
    },

    cancel: function() {
      var model = this.get('model');
      this.transitionToRoute('cajasImpresion');
    }
  }
});

Bodega.CajaImpresionEditController = Ember.ObjectController.extend({

  formTitle: 'Editar Caja de Impresión',
  
  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      
      model.save().then(function(response) {
        //success
        self.transitionToRoute('cajasImpresion');
      }, function(response) {
        //error
        model.rollback();
        console.log('caja_impresion_controller.js model.save() response: ' + response);
      });
    },

    cancel: function() {
      this.transitionToRoute('cajasImpresion');
    }
  }
});

Bodega.CajaImpresionDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
			$('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        self.transitionToRoute('cajasImpresion');
      });
    },

    cancel: function() {
			$('body').removeClass('modal-open');
      this.transitionToRoute('cajasImpresion');
    }
  }
});