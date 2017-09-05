Bodega.AjusteInventariosIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable,
  Bodega.mixins.Filterable, {
    resource:  'ajusteInventario'
});

Bodega.AjusteInventariosBaseController = Ember.ObjectController.extend({
  needs: ['application'],

  formTitle: 'Nuevo Ajuste de Inventario',

  productoSeleccionado : null,

  habilitarEdicionDetalle : true,

  enters: 2,

  feedback: Ember.Object.create(),



  checkExistencia: function() {
    var producto = this.get('productoSeleccionado');
    var detalle = this.get('detNuevo');
    var detalles = this.get('detalles');
    var feedback = this.get('feedback');
    var cantidadEnDetalles = 0;
    var existencia = 0;
    var loteDeposito = this.get('loteSeleccionadoModal');

    var self = this;
    var cantidadTemp = 0;


    if (producto && loteDeposito) {
        if (detalles) {
            detalles.forEach(function(detalle) {
              if ((detalle != null && detalle.get('producto').get('id') === producto.get('id') && !detalle.get('id')) && (detalle.get('lote.id') === loteDeposito.get('loteIdAux')) ) {
                cantidadEnDetalles = cantidadEnDetalles + parseFloat(detalle.get('cantidad'));
                console.log(cantidadEnDetalles);
              }
            });
        }
        existencia = loteDeposito.get('cantidad') + cantidadEnDetalles;
        console.log(cantidadEnDetalles);
        console.log('existencia: ' + existencia);
        self.set('existencia', 'Total: ' + existencia);

        if (detalle) {
            if (detalle != null && (parseInt(existencia) + parseInt(detalle.get('cantidad')) >= 0) ) {
                feedback.set('existencia', null);
                self.set('habilitaAgregar',true);
            }else if (!isNaN(parseInt(detalle.get('cantidad')))){
                feedback.set('existencia', "No se puede tener stock negativo");
                  self.set('habilitaAgregar',false);
            }
        } else {
            feedback.set('existencia', null);
        }
      }else {
        feedback.set('existencia', null);
    }

    this.set('existenciaDirty', existencia);

  }.observes('detNuevo.cantidad', 'productoSeleccionado','loteSeleccionadoModal'),

  clearProducto: function () {
    this.set('productoSeleccionado', null);
    this.set('productoSeleccionadoSW', null);
    this.set('descripcionSW', null);
    this.set('habilitaLote', false);
    this.set('loteSeleccionadoModal', null);

    var detalle = this.get('detNuevo');
    if(detalle){
        detalle.set('cantidad', 1);
        detalle.set('producto', null);
    }
  },



      loadFromSearchWidget: function () {
        console.log("InventariossBaseController->loadFromSearchWidget " + this.get('agregandoDetalle'));
        if (!this.get('agregandoDetalle')) {
            var productoSeleccionado = this.get('productoSeleccionadoSW');
            if (productoSeleccionado && productoSeleccionado.get('id') !== null) {
                var codigoBarraSW = productoSeleccionado.get('codigoBarra');
                this.set('codigoBarra', codigoBarraSW);
                this.loadProducto();
                console.log("InventariossBaseController->loadFromSearchWidget termino la carga");
            }
        }
      }.observes('productoSeleccionadoSW'),

      loadProducto: function(){
        var self = this;
        var depositoSeleccionado = this.get('depositoSeleccionado');
        var codigoBarra = this.get('codigoBarra');

        if (codigoBarra) {
          var productos = this.store.find('producto', {'codigo_barra' : codigoBarra, 'deposito_id': depositoSeleccionado.get('id')});
          productos.then(function(){
            var producto = productos.objectAt(0);
            var model = self.get('model');
            var detalle = self.get('detNuevo');
            if (producto) {
              self.set('productoSeleccionado', producto);
              self.set('codigoBarra', producto.get('codigoBarra'));
              detalle.set('producto', producto);
              var cantidad = 0;
              detalle.set('cantidad', cantidad);
              tipoProducto = producto.get('tipoProducto');
              tipoProducto.then(function(){
                if(tipoProducto.get('usaLote')){
                  console.log("El producto usa lote...");
                  self.set('habilitaLote',true);
                  loteDepositoParams = {};
                  loteDepositoParams.by_producto_id = producto.get('id');
                  loteDepositoParams.unpaged = true;
                  loteDepositoParams.usa_lote = true;
                  loteDepositoParams.by_deposito_id = depositoSeleccionado.get('id');
                  console.log("Obteniendo lotes...");
                  self.store.find('loteDeposito', loteDepositoParams).then(function(response){
                    console.log("Seteando lotes....", response);
                    self.set('lotesDeposito', response);
                    self.set('loteSeleccionadoModal', response.objectAt(0));
                  });
                }else{
                  self.set('habilitaLote',false);
                }
              });
            } else {
              self.set('productoSeleccionado', null);
              detalle.set('cantidad', 0);
            }
          });
        }
      },

  actions: {

    agregarDetalle: function() {
      var producto = this.get('productoSeleccionado');
      //var model = this.get('model');
      var detalle = this.get('detNuevo');
      var self = this;
      var loteDepisto = this.get('loteSeleccionadoModal');
      if (producto) {
        //crear el nuevo detalle
        detalle.set('producto', producto);
        //adjuntar a la lista de detalles
        if (this.get('habilitaLote')) {
          console.log("loteDepisto",loteDepisto);
          if (loteDepisto) {
            var lote = loteDepisto.get('lote');
            lote.then(function(response) {
              if(!self.get('habilitaAgregar')){
                Bodega.Notification.show('Atención', 'No se puede tener stock negativo en el lote seleccionado', Bodega.Notification.WARNING_MSG);
                return;
              }
              detalle.set('lote', response);
            });
          }else {
            Bodega.Notification.show('Atención', 'No existen lotes en el deposito seleccionado', Bodega.Notification.WARNING_MSG);
            return;
          }
        } else {
          if (loteDepisto.get('cantidad') - detalle.get('cantidad') < 0) {
            Bodega.Notification.show('Atención', 'No se puede tener stock negativo, solo existen ' + loteDepisto.get('cantidad') + ' unidades en el deposito Seleccionado', Bodega.Notification.WARNING_MSG);
            return;
          }
          var lote = this.store.find('lote',{'by_codigo': "loteUnico" + producto.get('id') });
          lote.then(function(response){
            console.log("lote",response.objectAt(0));
            detalle.set('lote', response.objectAt(0));
          });
        }



        this.set('detNuevo', this.store.createRecord('ajusteInventarioDetalle'));

        detalle.set('motivosInventario',this.get('motivoSeleccionado'));

        this.get('detalles').addRecord(detalle);
        if(!detalle.get('cantidad')){
          detalle.set('cantidad', 0);
        };
        self.set('existencia', null);

        this.set('codigoBarra', null);
        this.set('habilitaLote',false);
        this.clearProducto();
        $("#codigoBarra").focus();
        this.get('controllers.application').set('containerHeight', Bodega.newHeightWrapper(true));
      }
      this.set('count', 0);
    },

    borrarDetalle: function(detalle) {
      this.get('detalles').removeRecord(detalle);
      // detalle.deleteRecord();
      // detalle.save();
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

    resetCount: function () {
        //console.log("VentasBaseController->action->resetCount");
        var count = this.get('codigoBarra');
        if (count === "") {
            this.set('count', 0);
        }
    }.observes('codigoBarra'),


    cancel: function() {
      this.transitionToRoute('ajusteInventarios');
    },

    save: function() {
      var model = this.get('model');
      var self = this;
      var detalles = this.get('detalles');

      var depositoSeleccionado = this.get('depositoSeleccionado');

      if(depositoSeleccionado){
        model.set('deposito',depositoSeleccionado);
      }else{
        model.set('deposito',this.get('depositoDefault'));
      }

      model.set('motivosInventario',this.get('motivoSeleccionado'));



      if(detalles.get('length') > 0){
        Bodega.Utils.disableElement('button[type=submit]');
        if (model.get('isValid'))
        {
          model.save().then(function(response) {
            Bodega.Utils.enableElement('button[type=submit]');
            //guardar los detalles
            self.transitionToRoute('ajusteInventarios');
            if(self.get('edit')){
              Bodega.Notification.show('Éxito', 'El ajuste de inventario se ha actualizado.');
            }else{
              Bodega.Notification.show('Éxito', 'El ajuste de inventario se ha guardado.');
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
  }
});
//********************************************************************************************
Bodega.AjusteInventarioEditController = Bodega.AjusteInventariosBaseController.extend({

  formTitle: 'Editar Ajuste de Inventario',
  habilitarEdicionDetalle : false,

});

//********************************************************************************************
Bodega.AjusteInventariosNewController = Bodega.AjusteInventariosBaseController.extend({

  formTitle: 'Nuevo Ajuste de Inventario',
  habilitarEdicionDetalle : true,

});
//********************************************************************************************
