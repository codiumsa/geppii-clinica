Bodega.InventariosIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable,
  Bodega.mixins.Filterable, {
    resource:  'inventario'
});

Bodega.InventariosBaseController = Ember.ObjectController.extend({
  needs: ['application'],

  formTitle: 'Nuevo Inventario',

  productoSeleccionado : null,

  habilitarEdicionDetalle : true,

  enters: 2,


  depositoObserver: function() {
    var depositoDefault = this.get('depositoDefault');
    if (depositoDefault) {
      var detalles = this.get('detalles');
      if(detalles){
        detalles.clear();
      }
      this.set('lotes',null);
      this.set('loteSeleccionado',null);
      this.set('loteDefault',null);
      this.set('descripcionSW',null);
      this.set('habilitaLote',false);
      this.set('productoSeleccionadoSW',null);
      this.set('codigoBarra',null);
    }
  }.observes('depositoDefault'),

  loadFromSearchWidget: function () {
    console.log("InventariossBaseController->loadFromSearchWidget " + this.get('agregandoDetalle'));
    if (!this.get('agregandoDetalle')) {
        console.log("InventariossBaseController->loadFromSearchWidget agregandoDetalle false");
        var productoSeleccionado = this.get('productoSeleccionadoSW');
        ////console.log(productoSeleccionado);
        if (productoSeleccionado && productoSeleccionado.get('id') !== null) {
            console.log("InventariossBaseController->loadFromSearchWidget codigoBarra: " + this.get('codigoBarra'));
            var codigoBarraSW = productoSeleccionado.get('codigoBarra');
            this.set('codigoBarra', codigoBarraSW);
            this.loadProducto();
            console.log("InventariossBaseController->loadFromSearchWidget termino la carga");
        }
    }
  }.observes('productoSeleccionadoSW'),

  loadProducto: function(){
    console.log('InventariosBaseController->loadProducto');
    var codigoBarra = this.get('codigoBarra');
    var self = this;

    if (codigoBarra) {
      var origen = this.get('depositoDefault');

      var productos = this.store.find('producto', {'codigo_barra' : codigoBarra, 'deposito_id': origen.get('id')});
      productos.then(function(){
        var producto = productos.objectAt(0);
        var model = self.get('model');
        var detalle = self.get('detNuevo');
        if (producto) {
          self.set('productoSeleccionado', producto);
          self.set('codigoBarra', producto.get('codigoBarra'));
          self.set('descripcionSW',producto.get('descripcion'));
          detalle.set('producto', producto);
          var existencia = 0;
          detalle.set('existencia', existencia);

          tipoProducto = producto.get('tipoProducto');
          tipoProducto.then(function() {
            if (tipoProducto.get('usaLote')) {
              self.set('habilitaLote', true);
              loteDepositoParams = {};
              loteDepositoParams.by_deposito_id = origen.get('id');
              loteDepositoParams.by_producto_id = producto.get('id');
              loteDepositoParams.unpaged = true;
              loteDepositoParams.usa_lote = true;
              loteDepositoParams.by_excluye_fuera_de_stock = true;

              self.store.find('loteDeposito', loteDepositoParams).then(function(response) {
                self.set('lotes', response);
                self.set('loteSeleccionado', response.objectAt(0));
                self.set('loteDefault', response.objectAt(0));
              });

            } else {
              self.set('habilitaLote', false);
            }
          });
          $("#existencia").focus();
        } else {
          self.set('productoSeleccionado', null);
          detalle.set('existencia', 0);
          $("#codigoBarra").focus();
        }
      });
    }
  },
  clearProducto: function () {
    console.log("InventariossBaseController->clearProducto: " + !this.get('agregandoDetalle'));
    if (!this.get('agregandoDetalle')) {
        this.set('productoSeleccionado', null);
        this.set('productoSeleccionadoSW', null);
        this.set('descripcionSW', '');
        this.set('lotes',null);
        this.set('loteDefault', null);
        this.set('loteSeleccionado', null);
        var detalle = this.get('detNuevo');
        if(detalle){
            detalle.set('producto', null);
            detalle.set('existencia', 0)
            detalle.set('existenciaPrevia', 0);
            detalle.set('lote',null);
        }
    }
  }.observes('codigoBarra'),



  actions: {

    agregarDetalle: function() {
      console.log('InventariosBaseController->agregarDetalle');
      var producto = this.get('productoSeleccionado');
      var detalles = this.get('detalles');
      var detalle = this.get('detNuevo');
      var loteDepisto = this.get('loteSeleccionado');

      if (producto) {
        this.set('agregandoDetalle', true);
        //establecer el producto al nuevo detalle.
        detalle.set('producto', producto);

        //adjuntar a la lista de detalles
        this.set('descripcionSW', '');
        if (this.get('habilitaLote')) {
          console.log("loteDepisto",loteDepisto);
          if (loteDepisto) {
            var lote = loteDepisto.get('lote');
            lote.then(function(response) {
              console.log('lote',response);
              detalle.set('lote', response);
            });
          }else {
            Bodega.Notification.show('Atención', 'No existen lotes en el deposito seleccionado', Bodega.Notification.WARNING_MSG);
            return;
          }
        } else {
          var lote = this.store.find('lote',{'by_codigo': "loteUnico" + producto.get('id') });
          lote.then(function(response){
            console.log("lote",response.objectAt(0));
            detalle.set('lote', response.objectAt(0));
          });
        }
        this.set('detNuevo', this.store.createRecord('inventarioLote'));
        detalles.addRecord(detalle);
        detalle.set('dirty', false);
        this.set('productoSeleccionado', null);
        this.set('lotes', null);
        this.set('loteSeleccionado', null);
        this.set('descripcionSW', null);
        this.set('habilitaLote', false);
        this.set('productoSeleccionadoSW', null);
        this.set('codigoBarra', null);
        this.set('agregandoDetalle', false);
        this.set('existencia', null);
        this.get('controllers.application').set('containerHeight', Bodega.newHeightWrapper(true));
        this.clearProducto();
        $("#codigoBarra").focus();
      }
      this.set('count', 0);
    },

    borrarDetalle: function(detalle) {
      console.log("InventariossBaseController->borrarDetalle");
      this.get('detalles').removeRecord(detalle);
      // detalle.deleteRecord();
      // detalle.save();
      this.get('controllers.application').set('containerHeight', Bodega.newHeightWrapper());
    },

    contarEnters: function() {
      console.log("InventariosBaseController->action->contarEnters " + this.get('count'));
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

    resetCount: function () {
      console.log("InventariosBaseController->action->resetCount");
      var count = this.get('codigoBarra');
      if (count === "") {
          this.set('count', 0);
      }
    }.observes('codigoBarra'),

    cancel: function() {
      this.transitionToRoute('inventarios');
    },

    save: function() {
      console.log("InventariossBaseController->save");
      var model = this.get('model');
      var self = this;
      var detalles = this.get('detalles');

      var depositoSeleccionado = this.get('depositoSeleccionado');
      console.log('Procesado' + model.get('procesado'));
      if(!model.get('procesado')){
        console.log('Seteando procesado a FALSE;');
        model.set('procesado', false);
      }
      if(depositoSeleccionado){
        model.set('deposito',depositoSeleccionado);
      }else{
        model.set('deposito',this.get('depositoDefault'));
      }

      if(detalles.get('length') > 0){
        Bodega.Utils.disableElement('button[type=submit]');
        if (model.get('isValid'))
        {
          model.save().then(function(response) {
            Bodega.Utils.enableElement('button[type=submit]');
            //guardar los detalles
            self.transitionToRoute('inventarios');
            if(self.get('edit')){
              Bodega.Notification.show('Éxito', 'El inventario se ha actualizado.');
            }else{
              Bodega.Notification.show('Éxito', 'El inventario se ha guardado.');
            }
          }, function(response) {
            //error
            Bodega.Utils.enableElement('button[type=submit]');
          });
        } else {
          Bodega.Utils.enableElement('button[type=submit]');
        }
      }
    },
    procesar: function() {
      var model = this.get('model');
      var self = this;
      console.log('Procesar : poniendo como TRUE');
      model.set('procesado', true);
      console.log('Llamando a save');
      self.send('save');
    },
    cargarProducto: function() {
      console.log("InventariossBaseController->action->cargarProducto");
      this.set('count', 1);
      var producto = this.get('productoSeleccionado');
      if (producto) {
          this.send('agregarDetalle');
      } else {
          this.loadProducto();
      }
    },

  }
});
//********************************************************************************************
Bodega.InventarioEditController = Bodega.InventariosBaseController.extend({

  formTitle: 'Editar Inventario',
  //habilitarEdicionDetalle : true,

});

//********************************************************************************************
Bodega.InventariosNewController = Bodega.InventariosBaseController.extend({

  formTitle: 'Nuevo Inventario',
  //habilitarEdicionDetalle : true,

});
//********************************************************************************************
Bodega.InventarioDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
      $('body').removeClass('modal-open');
      var self = this;
      var model = this.get('model');
      model.destroyRecord().then(function(response) {
        self.transitionToRoute('inventarios');
        Bodega.Notification.show('Éxito', 'El inventario se ha eliminado.');
      }, function(response){
        self.transitionToRoute('transferenciasDeposito');
      });

    },

    cancel: function() {
      $('body').removeClass('modal-open');
      this.transitionToRoute('inventarios');
    }
  }
});
