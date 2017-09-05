Bodega.ProcesosIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable,
  Bodega.mixins.Filterable, {
  resource:  'proceso'
});


Bodega.ProcesosBaseController = Ember.ObjectController.extend({
  needs: ['application'],
  
  formTitle: 'Nuevo Proceso',

  productoSeleccionadoSW : null,

  habilitarEdicionDetalle : true,

  enters: 2,

  loadProductoSalida: function(){
    var codigoBarraSW = this.get('codigoBarraSW');
    var self = this;
    if(codigoBarraSW){
      var productos = this.store.find('producto', {'by_admite_proceso' : codigoBarraSW});
      productos.then(function(){
        var producto = productos.objectAt(0);
        if(producto){
          console.log(producto.get('descripcion'));
          self.set('descripcionProducto', producto.get('descripcion'));
          var model = self.get('model');
          model.set('producto', producto);
          //model.get('stateManager').send('becameClean');
        }
      });
    }
  }.observes('codigoBarraSW'),
  
  loadFromSearchWidget: function () {
        var productoSeleccionadoSW = this.get('productoSeleccionadoSW');
        console.log(productoSeleccionadoSW);
        if (productoSeleccionadoSW && productoSeleccionadoSW.get('id') !== null) {
            var codigoBarraSW = productoSeleccionadoSW.get('codigoBarra');
            this.set('codigoBarraSW', codigoBarraSW);
            this.loadProductoSalida();
        }
    }.observes('productoSeleccionadoSW'),

  loadDetailFromSearchWidget: function () {
        var detalleSeleccionadoSW = this.get('detalleSeleccionadoSW');
        console.log(detalleSeleccionadoSW);
        if (detalleSeleccionadoSW && detalleSeleccionadoSW.get('id') !== null) {
            var codigoBarraSW = detalleSeleccionadoSW.get('codigoBarra');
            this.set('codigoBarra', codigoBarraSW);
            this.loadProducto();
        }
    }.observes('detalleSeleccionadoSW'),

  loadProducto: function(){
    var codigoBarra = this.get('codigoBarra');
    var self = this;
    
    if (codigoBarra) {
      var productos = this.store.find('producto', {'codigo_barra' : codigoBarra});
      productos.then(function(){
        var producto = productos.objectAt(0);
        var model = self.get('model');
        var detalle = self.get('detNuevo');
        if (producto) {
          self.set('detalleSeleccionadoSW', producto);
          //self.set('descripcion', producto.get('descripcion'));
          detalle.set('producto', producto);
          var cantidad = 1;
          detalle.set('cantidad', cantidad);
        } else {
          self.set('detalleSeleccionadoSW', null);
          detalle.set('cantidad', 0);
        }
      });
    }
  }.observes('codigoBarra'),

  actions: {

    agregarDetalle: function() {
      var producto = this.get('detalleSeleccionadoSW');
      //var model = this.get('model');
      var detalle = this.get('detNuevo');
      if (producto) {
        //crear el nuevo detalle
        detalle.set('producto', producto);
        //adjuntar a la lista de detalles
        
        console.log(this.get('detalles'));
        this.set('detNuevo', this.store.createRecord('procesoDetalle'));
        this.get('detalles').addRecord(detalle);
        this.set('detalleSeleccionadoSW', null);
        $("#codigoBarra").focus();
        $("#codigoBarra").val('');

        this.get('controllers.application').set('containerHeight', Bodega.newHeightWrapper(true));

      }
      this.set('count', 0);
    },

    borrarDetalle: function(detalle) {
      this.get('detalles').removeRecord(detalle);
      detalle.deleteRecord();
      detalle.save();
      this.get('controllers.application').set('containerHeight', Bodega.newHeightWrapper());
    },

    contarEnters: function() {
      
      //console.log(this.get('enters'));
      var count = this.get('count');
      if (count === undefined) {
        count = 0;
        this.set('count', count);
      }

      count = count + 1;
      //console.log(count);
      if (count >= this.get('enters')) {
        this.set('count', 0);
        this.send('agregarDetalle');
      } else {
        this.set('count', count);
      }
    },

    
    cancel: function() {
      this.transitionToRoute('procesos');
    },

    save: function() {
      console.log("ProcesosController.js - save");
      var model = this.get('model');
      var self = this;
      Bodega.Utils.disableElement('button[type=submit]');
      var detalles = this.get('detalles');
      if (detalles.get('length') > 0) {
        if(model.get('isValid')) {
          model.save().then(function(response) {
            detalles.save().then (function(response) {
              model.save().then(function(argument) {
                Bodega.Notification.show('Éxito', 'El proceso de producción se ha creado.');
                Bodega.Utils.enableElement('button[type=submit]');
                self.transitionToRoute('procesos');
              });
            });
          }, function(response) {
            Bodega.Notification.show('Error', 'El proceso no se pudo crear', 'error');
            Bodega.Utils.enableElement('button[type=submit]');
            //model.rollback();
          });
        }else{
          Bodega.Utils.enableElement('button[type=submit]');
        }
      }else{
        Bodega.Notification.show('Error', 'El proceso no cuenta con materias primas.', 'error');
        Bodega.Utils.enableElement('button[type=submit]');
        console.log("ProcesosController.js - No se hizo nada. Agregar notificación. ");
      }
    }
  }
});
//********************************************************************************************
Bodega.ProcesoEditController = Bodega.ProcesosBaseController.extend({

  formTitle: 'Editar Proceso',
  habilitarEdicionDetalle : false,
  
});

//********************************************************************************************
Bodega.ProcesosNewController = Bodega.ProcesosBaseController.extend({

  formTitle: 'Nuevo Proceso',
  habilitarEdicionDetalle : true,

  
});
//********************************************************************************************
Bodega.ProcesoDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
      $('body').removeClass('modal-open');
      var self = this;
      var model = this.get('model');
      model.destroyRecord().then(function(response) {
        self.transitionToRoute('procesos');
      }, function(response){
        model.transitionTo('uncommitted');
        Bodega.Notification.show('Error', 'No se pudo borrar el registro de producción.', Bodega.Notification.ERROR_MSG);
        self.transitionToRoute('procesos');        
      });
      
    },

    cancel: function() {
      $('body').removeClass('modal-open');
      this.transitionToRoute('procesos');
    }
  }
});