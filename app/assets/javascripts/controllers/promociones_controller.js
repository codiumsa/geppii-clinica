Bodega.PromocionesIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable, 
  Bodega.mixins.Filterable, {
    perPage:  15,
    resource:  'promocion',
    staticFilters: {
     by_activo: true
    }
});

Bodega.PromocionBaseController = Ember.ObjectController.extend({
  needs: ['application'],
  
  formTitle: '',

  mensajeExito: '',

  numeral: '#',

  productoSeleccionado : null,
  detalleReadOnly: true,

  ckTemporal : true,
  ckGeneral : true,
  ckTarjeta: false,
  agregandoDetalle: false,
  feedback :  Ember.Object.create(),

  loadProducto: function(){
    if (!this.get('agregandoDetalle')) {
      var codigoBarra = this.get('codigoBarra');
      var self = this;
      var descripcionSW = this.get('descripcionSW');
      var detalle = this.get('detNuevo');

      if (codigoBarra) {
        var productos = this.store.find('producto', {'codigo_barra' : codigoBarra, 
                                                      'by_activo' : true});

        detalle.set('dirty', true);

        productos.then(function() {
          //var detalle = self.get('detNuevo');
          if (!self.get('agregandoDetalle') && detalle.get('dirty')) {
            var producto = productos.objectAt(0);
            var model = self.get('model');
            var moneda = producto.get('moneda');
            var tipoProducto = producto.get('tipoProducto');
            //var detalle = self.get('detNuevo');
            if (producto) {
              self.set('productoSeleccionado', producto);

              detalle.set('descripcion', producto.get('descripcion'));

              detalle.set('producto', producto);
              tipoProducto.then(function(){
                if (tipoProducto.get('servicio')) {
                  detalle.set('caliente', false);
                }
              });
              

              var cantidad = 1;
              detalle.set('cantidad', cantidad);

              var precio = producto.get('precio');
              detalle.set('precio', precio);
              self.set('descripcionSW', producto._data.descripcion);
              var descuento = 0;

              moneda.then(function(response) {
                self.set('moneda', moneda.get('content'));
              });


            } else {
              self.set('productoSeleccionado', null);
              self.set('descripcionSW', '');
              detalle.set('cantidad', 0);
              detalle.set('precio', 0);
            }
          }
        });
      }
    }
  },

  checkPositivo: function () {
    var model = this.get('model');
    var feedback = this.get('feedback');
    var detalle = this.get('detNuevo');

    if (model) {
      var descuento = model.get('porcentajeDescuento');
      var cantidad = model.get('cantidadGeneral');
      
      if (detalle) {
        var detDescuento = detalle.get('precioDescuento');
        var detCantidad = detalle.get('cantidad');
        var descripcionSW = this.get('descripcionSW');
        $('.tt-input').val(descripcionSW);
        if (detDescuento < 0) {
          detalle.set('precioDescuento', 0);
        }
        if (detCantidad < 0) {
          detalle.set('cantidad', 0);
        }

      }
      if (descuento < 0) {
        model.set('porcentajeDescuento', 0);
      }
      if (cantidad < 0) {
        model.set('cantidadGeneral', 0);
      }
    }
       
  }.observes('porcentajeDescuento', 'detNuevo.precioDescuento', 'detNuevo.cantidad', 'cantidadGeneral'),

  clearProducto: function () {
    if (!this.get('agregandoDetalle')) {
        this.set('productoSeleccionado', null);
        this.set('descripcionSW', '');
        this.set('moneda', null);
    }
  }.observes('codigoBarra'),

  checkFecha: function () {
    var model = this.get('model');
    var feedback = this.get('feedback');

    var fd = model.get('fechaVigenciaDesde');
         
    if (model) {
      var permanente = model.get('permanente');
      if (permanente){
        this.set('ckTemporal', false);
        model.set('fechaVigenciaHasta', null);
        feedback.set('fecha', null);
        if (!feedback.get('positivo'))
          feedback.set('conErrores', null);
      } else {
        this.set('ckTemporal', true);
        if (model.get('fechaVigenciaHasta') === null){
          model.set('fechaVigenciaHasta', model.get('fechaVigenciaDesde'));
        }
        if (fd.setHours(0,0,0,0) > model.get('fechaVigenciaHasta').setHours(0,0,0,0)){
          feedback.set('fecha', "La fecha de inicio debe ser menor que la fecha de fin");
          feedback.set('conErrores', true);
        }
      }
        
    }      

  }.observes('fechaVigenciaDesde', 'fechaVigenciaHasta', 'permanente'),

  checkTarjeta: function() {
    var model = this.get('model');
    var feedback = this.get('feedback');
    var conTarjeta = model.get('conTarjeta');
    var exclusiva = model.get('exclusiva');

    if(model) {

      if(conTarjeta && exclusiva) {
        feedback.set('tarjeta', 'Una promoción de tarjeta no puede ser exclusiva');
        feedback.set('conErrores', true);
      }else{
        feedback.set('tarjeta', null);
        feedback.set('conErrores', false);
      }
      this.set('ckTarjeta', conTarjeta);
    }
  }.observes('conTarjeta', 'exclusiva'),

  loadFromSearchWidget: function () {
    if (!this.get('agregandoDetalle')) {
      var productoSeleccionado = this.get('productoSeleccionadoSW');
     // console.log(productoSeleccionado);
      if (productoSeleccionado && productoSeleccionado.get('id') !== null) {
          var codigoBarraSW = productoSeleccionado.get('codigoBarra');
          this.set('codigoBarra', codigoBarraSW);
          this.loadProducto();
      }
    }
  }.observes('productoSeleccionadoSW'),

  tarjetaSeleccionadaObserver: function() {

    var tarjeta = this.get('tarjetaSeleccionada');
    var model = this.get('model');
    model.set('tarjeta', tarjeta);
  }.observes('tarjetaSeleccionada'),


  actions: {

    save: function() {

      var model = this.get('model');
      var self = this;
      var detalles = this.get('detalles');
      var exito = this.get('mensajeExito');
      var menError = this.get('mensajeError');
      var feedback = this.get('feedback');
      Bodega.Utils.disableElement('button[type=submit]');

      if (model.get('isValid') && !feedback.get('conErrores')) {
        if (!model.get('porcentajeDescuento')) {
          model.set('porcentajeDescuento', 0);
        }
        if (!model.get('cantidadGeneral')) {
          model.set('cantidadGeneral', 0);
        }
        model.save().then(function(response) {
          
          self.transitionToRoute('promociones');
          Bodega.Notification.show('Éxito', exito);
        }, function(response) {
          Bodega.Utils.enableElement('button[type=submit]');
        });
      } else {
        Bodega.Utils.enableElement('button[type=submit]');
      }
      
    },

    agregarDetalle: function() {
      var producto = this.get('productoSeleccionado');
      var detalle = this.get('detNuevo');
      if (producto) {
        //crear el nuevo detalle
        this.set('agregandoDetalle', true);
        var detDescuento = detalle.get('precioDescuento');
        var detCantidad = detalle.get('cantidad');
        if (!detDescuento) {
          detalle.set('precioDescuento', 0);
        }
        if (!detCantidad) {
          detalle.set('cantidad', 0);
        }

        detalle.set('producto', producto);
        detalle.set('moneda', this.get('moneda'));
        //adjuntar a la lista de detalles

        this.set('detNuevo', this.store.createRecord('promocionProducto'));
        this.get('detalles').addRecord(detalle);

        this.set('productoSeleccionado', null);
        
        this.set('codigoBarra', null);
        this.set('descripcionSW', '');
        this.get('controllers.application').set('containerHeight', Bodega.newHeightWrapper(true));

        this.clearProducto();
        this.set('agregandoDetalle', false);
        $("#codigoBarra").focus();

      }
      this.set('count', 0);
    },

    borrarDetalle: function(detalle) {
      this.get('detalles').removeRecord(detalle);
      detalle.deleteRecord();
      detalle.save();
      this.get('controllers.application').set('containerHeight', Bodega.newHeightWrapper());
    },

    cancel: function() {
      //this.get('model').rollback();
      this.transitionToRoute('promociones');
    },

    contarEnters: function() {
      var count = this.get('count');
      if (count === undefined) {
        count = 0;
        this.set('count', count);
      }

      count = count + 1;

      if (count >= this.get('enters')) {
        this.set('count', 0);
        this.send('agregarDetalle');
      } else {
        this.set('count', count);
      }
    },

    cargarProducto: function() {
      var producto = this.get('productoSeleccionado');
      if (producto) {
        this.send('agregarDetalle');
      } else {
        this.loadProducto();
      }
    }

  }
});

Bodega.PromocionesNewController = Bodega.PromocionBaseController.extend({
  formTitle: 'Nueva Promoción',
  mensajeExito: 'La promoción se ha creado',
  mensajeError: 'No se pudo crear la promoción'
});

Bodega.PromocionEditController = Bodega.PromocionBaseController.extend({
  formTitle: 'Editar Promoción',
  mensajeExito: 'La promoción se ha actualizado',
  mensajeError: 'No se pudo actualizar la promoción'
});

Bodega.PromocionDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
			$('body').removeClass('modal-open');
      var self = this;
      var model = this.get('model');
      model.destroyRecord().then(function(response) {
        self.transitionToRoute('promociones');
        Bodega.Notification.show('Éxito', 'La promoción se ha eliminado.');
      }, function(response){
        var error = response.errors;
        model.transitionTo('uncommitted');
        Bodega.Notification.show('Error', 'No se pudo borrar la promoción. ' + error.base[0], Bodega.Notification.ERROR_MSG);
        self.transitionToRoute('promociones');        
      });
      
    },

    cancel: function() {
			$('body').removeClass('modal-open');
      this.transitionToRoute('promociones');
    }
  }

});