
Bodega.TransferenciasDepositoIndexController = Ember.ArrayController.extend(Bodega.mixins.Pageable, Bodega.mixins.Filterable, {
  resource:  'transferenciaDeposito',
  hasSearchForm: true,
  searchFormTpl: 'transferencias_deposito/searchform',
  searchFormModal: '#transferenciaDepositoSearchForm',

  clearSearchForm: function() {

    this.set('fechaAntes', '');
    this.set('fechaDia', '');
    this.set('fechaDespues', '');
    this.set('selectedOrigen', null);
    this.set('selectedDestino', null);
  },

  actions: {
    criteriaSearch: function() {
      var self = this;
      var staticFilters = this.get('staticFilters');
      var fechaAntes = this.get('fechaAntes');
      var fechaDia = this.get('fechaDia');
      var fechaDespues = this.get('fechaDespues');
      var selectedOrigen = this.get('selectedOrigen');
      var selectedDestino = this.get('selectedDestino');

      if(fechaAntes){
        staticFilters.by_fecha_registro_before = fechaAntes;
      }

      if(fechaDespues){
        staticFilters.by_fecha_registro_after = fechaDespues;
      }

      if(fechaDia){
        staticFilters.by_fecha_registro_on = fechaDia;
      }

      if(selectedOrigen){
        staticFilters.by_origen_id = selectedOrigen.get('id');
      }

      if(selectedDestino){
        staticFilters.by_destino_id = selectedDestino.get('id');
      }

      this.set('staticFilters', staticFilters);
      this.store.find('transferenciaDeposito', staticFilters).then(function(model) {
        self.set('model', model);
      });
    }
  }

});

Bodega.TransferenciasDepositoBaseController = Ember.ObjectController.extend({
  needs: ['application'],

  productoSeleccionado : null,

  habilitarEdicionDetalle : true,

  habilitaLote: false,

  enters: 2,

  origenController: null,

  feedback: Ember.Object.create(),

  loadFromSearchWidget: function() {
    //console.log("VentasBaseController->loadFromSearchWidget");
    if (!this.get('agregandoDetalle')) {
      console.log('entra1');
      //console.log("VentasBaseController->loadFromSearchWidget agregandoDetalle false");
      var productoSeleccionado = this.get('productoSeleccionadoSW');
      ////console.log(productoSeleccionado);
      if (productoSeleccionado && productoSeleccionado.get('id') !== null) {
        console.log('entra2');
        var codigoBarraSW = productoSeleccionado.get('codigoBarra');
        this.set('codigoBarra', codigoBarraSW);
        this.loadProducto();
      }
    }
  }.observes('productoSeleccionadoSW'),

  searchDepositoOrigen: function() {
    var origenController = this.get('origenController');
    console.log('origen',origenController);
      if (origenController == null){
        console.log('nulllll');
        this.set('settedOrigen',false);
        this.set('lotes',null);
        this.set('loteSeleccionado',null);
        this.set('loteDefault',null);
        this.set('descripcionSW',null);
        this.set('habilitaLote',false);
        this.set('productoSeleccionadoSW',null);
        this.set('codigoBarra',null);
        this.set('queryScopeOrigen', null);
        var detalles = this.get('detalles');
        if(detalles){
          detalles.clear();
        }
        console.log('Habilitando codigo de barra');
        console.log(this.get('origenController'));
        var habilitarCodigoBarra = this.get('habilitarEdicionDetalle') && this.get('origenController') != null;
        this.set('habilitarCodigoBarra', habilitarCodigoBarra);
      }else{
        var self = this;
        this.set('lotes',null);
        this.set('loteSeleccionado',null);
        this.set('loteDefault',null);
        this.set('descripcionSW',null);
        this.set('habilitaLote',false);
        this.set('productoSeleccionadoSW',null);
        this.set('codigoBarra',null);
        console.log(origenController.get('id'));
        this.set('settedOrigen',false);

        var queryScopeOrigen = '';
        // queryScopeOrigen+= 'by_deposito=' + origenController.get('id');
        queryScopeOrigen+= 'by_stock';
        console.log('Guardando queryScopeTratamientos: ', queryScopeOrigen);
        var habilitarCodigoBarra = this.get('habilitarEdicionDetalle') && this.get('origenController') != null;
        this.set('habilitarCodigoBarra', habilitarCodigoBarra);
        this.set('queryScopeOrigen', null);
        this.set('queryScopeOrigen', queryScopeOrigen);
        this.set('settedOrigen',true);
      }

  }.observes('origenController'),

  origenSWObserver: function(){
    if (this.get('origenSW') == '') {
      this.set('origenController',null);
    }
  }.observes('origenSW'),

  loadProducto: function(){
    console.log('InventariosBaseController->loadProducto');
    var codigoBarra = this.get('codigoBarra');
    var self = this;

    if (codigoBarra) {
        var model = self.get('model');
        var origen = this.get('origenController');
        var productos = this.store.find('producto', {'codigo_barra' : codigoBarra, 'deposito_id': origen.get('id')});
        productos.then(function(){
        var producto = productos.objectAt(0);
        var detalle = self.get('detNuevo');
        if (producto) {
          self.set('productoSeleccionado', producto);
          self.set('codigoBarra', producto.get('codigoBarra'));
          self.set('descripcionSW',producto.get('descripcion'));
          detalle.set('producto', producto);
          var existencia = 1;
          detalle.set('cantidad', existencia);
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
                if (response.content.length == 0) {
                  Bodega.Notification.show('Atención', 'No existen lotes en el deposito origen seleccionado', Bodega.Notification.WARNING_MSG);
                }
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
    if (!this.get('agregandoDetalle')) {
        this.set('descripcionSW', null);
        this.set('productoSeleccionadoSW', null);
        this.set('productoSeleccionado', null);
        this.set('loteSeleccionado', null);
        this.set('loteDefault', null);
        this.set('habilitaLote', false);
        this.set('lotes');

        this.set('descripcionSW', '');
        var detalle = this.get('detNuevo');

        if(detalle){
            detalle.set('producto', null);
            detalle.set('existencia', 0)
            detalle.set('existenciaPrevia', 0);
        }
    }
  }.observes('codigoBarra'),

  imprimirTransferencia: function(transferencia_deposito) {
    var params = {};
    params.content_type = 'pdf';
    params.transferencia_deposito_id = transferencia_deposito.get('id');
    Bodega.Utils.printPdf('/api/v1/transferencias_deposito/', params);
  },


  actions: {

    agregarDetalle: function() {
      var loteDepisto = this.get('loteSeleccionado');
      //var model = this.get('model');
      var feedback = this.get('feedback');

      if (feedback.get('existencia')) {
        return;
      }

      var detalle = this.get('detNuevo');
      console.log("loteDepisto",loteDepisto);
      console.log("this.get('habilitaLote')",this.get('habilitaLote'));
      if (this.get('habilitaLote')) {
        console.log("loteDepisto",loteDepisto);

        if (loteDepisto) {
          if (loteDepisto.get('cantidad') < detalle.get('cantidad')) {
            Bodega.Notification.show('Atención', 'No existen ' + detalle.get('cantidad') + ' unidades en el lote seleccionado', Bodega.Notification.WARNING_MSG);
            return;
          }
          var lote = loteDepisto.get('lote');
          lote.then(function(response) {
            console.log('lote',response);
            detalle.set('lote', response);
          });
        }else {
          Bodega.Notification.show('Atención', 'No existen lotes en el deposito origen seleccionado', Bodega.Notification.WARNING_MSG);
          return;
        }
      } else {
        var lote = this.store.find('lote',{'by_codigo': "loteUnico" + producto.get('id') });
        lote.then(function(response){
          console.log("lote",response.objectAt(0));
          detalle.set('lote', response.objectAt(0));
        });
        // detalle.set('codigoLote', "loteUnico" + producto.get('id'));
      }
      this.set('detNuevo', this.store.createRecord('transferenciaDepositoDetalle'));
      this.set('agregandoDetalle',true);
      this.get('detalles').addRecord(detalle);
      this.set('agregandoDetalle',false);
      this.set('productoSeleccionado', null);
      this.set('loteSeleccionado', null);
      this.set('codigoBarra', null);
      this.set('habilitaLote',false);
      $("#codigoBarra").focus();
      $("#codigoBarra").val('');
      this.get('controllers.application').set('containerHeight', Bodega.newHeightWrapper(true));
      this.set('count', 0);
    },

    borrarDetalle: function(detalle) {
      this.get('detalles').removeRecord(detalle);
      // detalle.deleteRecord();
      // detalle.save();
      // this.get('controllers.application').set('containerHeight', Bodega.newHeightWrapper());
      $("#destino").focus();
    }.observes('origenController'),

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
      this.transitionToRoute('transferenciasDeposito');
    },

    save: function() {
        var model = this.get('model');
        var self = this;
        var detalles = this.get('detalles');
        var errors = model.get('errors');
        var origenController = this.get('origenController');
        if (origenController != null) {
          this.store.find('deposito',origenController.get('id')).then(function(response){
            model.set('origen',response);

            //model.set('prueba', this.get('detalles'));

            if(model.get('origen') && errors.has('origen')) {
              // eliminamos los mensajes de error relacionados al producto padre ya que
              // el atributo dejó de ser undefined
              errors.remove('origen');
            }

            if(model.get('destino') && errors.has('destino')) {
              // eliminamos los mensajes de error relacionados al producto padre ya que
              // el atributo dejó de ser undefined
              errors.remove('destino');
            }

            if(detalles.get('length') > 0){
              Bodega.Utils.disableElement('button[type=submit]');
              if(model.get('isValid')) {
                model.save().then(function(response) {
                  Bodega.Utils.enableElement('button[type=submit]');
                  //guardar los detalles e imprime
                  // if(self.get('soportaImprimirRemision')) {
                  //       self.imprimirTransferencia(response);
                  // }
                  self.transitionToRoute('transferenciasDeposito');
                  if(self.get('edit')){
                    Bodega.Notification.show('Éxito', 'La transferencia se ha actualizado.');
                  }else{
                    Bodega.Notification.show('Éxito', 'La transferencia se ha guardado.');
                  }
                }, function(response) {
                  Bodega.Utils.enableElement('button[type=submit]');
                  var erroresDetalles = response.errors.base;
                  if(erroresDetalles){
                    for(var i=0; i<erroresDetalles.length; i++){
                      Bodega.Notification.show('Error', erroresDetalles[i], Bodega.Notification.ERROR_MSG);
                    }
                  }
                });
              }else{
                Bodega.Utils.enableElement('button[type=submit]');
              }
            }


          });
        }


    },

    cargarProducto: function() {
      console.log("InventariossBaseController->action->cargarProducto");
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
Bodega.TransferenciaDepositoEditController = Bodega.TransferenciasDepositoBaseController.extend({

  formTitle: 'Editar Transferencia',
  habilitarEdicionDetalle : false,
  habilitarCodigoBarra: false


});

//********************************************************************************************
Bodega.TransferenciasDepositoNewController = Bodega.TransferenciasDepositoBaseController.extend({

  formTitle: 'Nueva Transferencia',
  habilitarEdicionDetalle : true,
  habilitarCodigoBarra: true



});
//********************************************************************************************
Bodega.TransferenciaDepositoDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
			$('body').removeClass('modal-open');
      var self = this;
      var model = this.get('model');
      model.destroyRecord().then(function(response) {
        self.transitionToRoute('transferenciasDeposito');
        Bodega.Notification.show('Éxito', 'La transferencia se ha eliminado.');
      }, function(response){
        model.transitionTo('uncommitted');
        var faltaStock = response.errors.base;
        if(faltaStock){
          for(var i=0; i<faltaStock.length; i++){
            Bodega.Notification.show('Error', faltaStock[i], Bodega.Notification.ERROR_MSG);
          }
        }else{
          Bodega.Notification.show('Error', 'No se pudo borrar la transferencia.', Bodega.Notification.ERROR_MSG);
        }
        self.transitionToRoute('transferenciasDeposito');
      });

    },

    cancel: function() {
			$('body').removeClass('modal-open');
      this.transitionToRoute('transferenciasDeposito');
    }
  }
});
