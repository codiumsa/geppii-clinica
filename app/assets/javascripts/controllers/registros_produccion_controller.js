Bodega.RegistrosProduccionIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable, 
  Bodega.mixins.Filterable,{
  perPage:  10,
  resource:  'registroProduccion',

  actions: {
    iniciar: function(model) {
      console.log("RegistrosProduccionIndexController.iniciar ");
      var self = this;
      model.set('estado', 'INICIADO');
      if(model.get('isValid')) {
        model.save().then(function(response) {
            console.log("Produccion iniciada correctamente.");
            self.transitionToRoute('registrosProduccion').then(function (){
              Bodega.Notification.show('Éxito', 'La materia prima ha sido extraida del deposito.');
              Bodega.Utils.enableElement('button[type=submit]');
            });
          }, function(response){
            console.log("No se puede iniciar la produccion");
            // model.rollback();
            // model.transitionTo('uncommitted');
            model.set('estado', 'REGISTRADO');
            var faltaStock = response.errors.base;
            if(faltaStock){
              for(var i=0; i<faltaStock.length; i++){
                Bodega.Notification.show('Error', faltaStock[i], Bodega.Notification.ERROR_MSG);
              }
            }else{
              Bodega.Notification.show('Error', 'No se puede iniciar la producción.', Bodega.Notification.ERROR_MSG);
            }
            // self.set('model', self.store.find('registroProduccion', {page: 1}));
            console.log('... ... ... Finalizando');
            self.transitionToRoute('registrosProduccion');        
          } 
        );
      }else{
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },

    terminar: function(model) {
      console.log("RegistrosProduccionIndexController.iniciar ");
      var self = this;
      model.set('estado', 'TERMINADO');
      if(model.get('isValid')) {
        model.save().then(
          function(response) {
            // success
            self.transitionToRoute('registrosProduccion').then(function (){
              Bodega.Notification.show('Éxito', 'Los productos fueron agregados al depósito: ' + model.get('deposito').get('descripcion'));
              Bodega.Utils.enableElement('button[type=submit]');
            });
          }, function(response){
            model.rollback();
            model.transitionTo('uncommitted');
            var faltaStock = response.errors.base;
            if(faltaStock){
              for(var i=0; i<faltaStock.length; i++){
                Bodega.Notification.show('Error', faltaStock[i], Bodega.Notification.ERROR_MSG);
              }
            }else{
              Bodega.Notification.show('Error', 'No se puede iniciar la producción.', Bodega.Notification.ERROR_MSG);
            }
            self.transitionToRoute('registrosProduccion').then(function() {
              console.log("EN EL TRANSITION TO ROUTE");
              this.render('registrosProduccion.index', {controller: 'registroProduccionIndex'});
            });      
          }
        );
      }else{
        Bodega.Utils.enableElement('button[type=submit]');
      }

    }
  }
});

// Base Controller
Bodega.RegistrosProduccionBaseController = Ember.ObjectController.extend({

  feedback : Ember.Object.create(),

  transferencia : false,

  actions: {
    save: function() {
      console.log("RegistrosProduccionNewController.save ");
      var model = this.get('model');
      var self = this;
      Bodega.Utils.disableElement('button[type=submit]');
      var proceso = this.get('procesoDefault');
      model.set('proceso', proceso);
      
      var deposito = this.get('depositoDefault');
      model.set('deposito', deposito);
      
      console.log("Deposito y Proceso seteados. Model.save ");
      if(model.get('isValid')) {
        model.save().then(
          function(response) {
            // success
            self.transitionToRoute('registrosProduccion').then(function (){
              Bodega.Notification.show('Éxito', 'El registro se ha actualizado.');
              Bodega.Utils.enableElement('button[type=submit]');
            });
          }, function(response){
            //model.rollback();
            model.transitionTo('uncommitted');
            var faltaStock = response.errors.base;
            if(faltaStock){
              for(var i=0; i<faltaStock.length; i++){
                Bodega.Notification.show('Error', faltaStock[i], Bodega.Notification.ERROR_MSG);
              }
            }else{
              Bodega.Notification.show('Error', 'No se puede guardar la producción.', Bodega.Notification.ERROR_MSG);
            }
            Bodega.Utils.enableElement('button[type=submit]');
            //self.transitionToRoute('registrosProduccion');        
          }
        );
      }else{
        Bodega.Utils.enableElement('button[type=submit]');
      }
    }
  },
  checkProceso: function () {
    var model = this.get('model');
    var self = this;
    var proceso = this.get('procesoDefault');
    if(!proceso){
      return;
    }
    model.set('cantidad', proceso.get('cantidad'));
    console.log("productoDescripcion" + '  ' +proceso.get('descripcion') + '  '+ proceso.get('producto'));

    proceso.get('producto').then(function() {
      self.set('descripcionProducto', proceso.get('producto').get('descripcion'));
    });
  }.observes('procesoDefault'),
});

// New Controller
Bodega.RegistrosProduccionNewController = Bodega.RegistrosProduccionBaseController.extend({

  formTitle: 'Nuevo registro de producción',

  actions: {
    cancel: function() {
      console.log("RegistrosProduccionNewController.cancel ");
      var model = this.get('model');
      if(model){
        model.deleteRecord();
      }

      this.transitionToRoute('registrosProduccion');
    }
  }
});

// Edit Controller
Bodega.RegistroProduccionEditController = Bodega.RegistrosProduccionBaseController.extend({
  formTitle: 'Editar registro de producción',

  actions: {
    cancel: function() {
      console.log("RegistrosProduccionEditController.cancel ");
      var model = this.get('model');
      if(model){
        model.deleteRecord();
      }

      this.transitionToRoute('registrosProduccion');
    }
  }
});


Bodega.RegistroProduccionDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
			$('body').removeClass('modal-open');
      var self = this;
      var model = this.get('model');
      model.destroyRecord().then(function(response) {
        self.transitionToRoute('registrosProduccion');
      }, function(response){
        model.transitionTo('uncommitted');
        var faltaStock = response.errors.base;
        if(faltaStock){
          for(var i=0; i<faltaStock.length; i++){
            Bodega.Notification.show('Error', faltaStock[i], Bodega.Notification.ERROR_MSG);
          }
        }else{
          Bodega.Notification.show('Error', 'No se pudo borrar el registro de producción.', Bodega.Notification.ERROR_MSG);
        }
        self.transitionToRoute('registrosProduccion');        
      });
      
    },

    cancel: function() {
			$('body').removeClass('modal-open');
      this.transitionToRoute('registrosProduccion');
    }
  }
});
