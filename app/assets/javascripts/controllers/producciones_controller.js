Bodega.ProduccionesIndexController = Ember.ArrayController.extend(Bodega.mixins.Pageable, Bodega.mixins.Filterable,{
  resource:  'tipo_producto',
  perPage:  15,
});

//******************************ProductoNew****************************************************



Bodega.ProduccionesNewController = Ember.ObjectController.extend({

  formTitle: 'Nueva Producción',
  detalles: Ember.computed('listaDetalles.@each.id', function(){ return this.get('listaDetalles'); }),



  cargaProductos: function(){
    var self = this;
    var producto = this.get('productoSetSeleccionado');
    var deposito = this.get('depositoSeleccionado');
    // var listaDetalles = this.get('listaDetalles');

    if(deposito && producto){
      console.log('Cargando producto.....', producto.get('descripcion'), deposito.get('nombre'));
      this.set('agregandoDetalle', true);

      this.store.find('productoDetalle', {'by_producto_padre': this.get('productoSetSeleccionado.id')}).then(function(response){
        self.set('detalles',response);

      });

    }
  }.observes('productoSetSeleccionado', 'depositoSeleccionado'),

  actions: {

    save: function() {
      var model = this.get('model');
      var self = this;
      var error = false;
      var promises = [];
      var errores = [];
      var deposito = this.get('depositoSeleccionado');
      var cantidadAProducir = this.get('cantidadProduccion');
      var cantidadDetalles = {};
      var producto = this.get('productoSetSeleccionado');

      var detalles = this.get('detalles');
      (detalles.content).forEach(function(value) {
        // console.log(value);

        loteDepositoParams = {};
        loteDepositoParams.by_producto_id = value._data.producto.id;
        loteDepositoParams.unpaged = true;
        loteDepositoParams.usa_lote = true;
        // loteDepositoParams.by_excluye_fuera_de_stock = true;
        loteDepositoParams.by_deposito = self.get('depositoSeleccionado.id');
        if(cantidadDetalles.hasOwnProperty(value._data.producto.id)){
          console.log((cantidadDetalles[value._data.producto.id].cantidadRequerida + value._data.cantidad) * cantidadAProducir);
          cantidadDetalles[value._data.producto.id].cantidadRequerida = (cantidadDetalles[value._data.producto.id].cantidadRequerida + value._data.cantidad) * cantidadAProducir;
        }else{
          console.log(value._data.cantidad * cantidadAProducir);
          cantidadDetalles[value._data.producto.id] = {};
          cantidadDetalles[value._data.producto.id].cantidadRequerida = value._data.cantidad * cantidadAProducir;
          cantidadDetalles[value._data.producto.id].producto = value._data.producto;
        }
        var promise = self.store.find('loteDeposito', loteDepositoParams);
        promise.then(function(loteDepositos){
          if(loteDepositos.content.length > 0){
            loteDepositos.forEach(function(loteDepositoTemp){
              if(cantidadDetalles[value._data.producto.id].hasOwnProperty('cantidadEnStock')){
                if(!_.includes(cantidadDetalles[value._data.producto.id].loteId, loteDepositoTemp.get('id'))){
                  cantidadDetalles[value._data.producto.id].cantidadEnStock = cantidadDetalles[value._data.producto.id].cantidadEnStock  + loteDepositoTemp.get('cantidad');
                }
              }else{
                cantidadDetalles[value._data.producto.id].cantidadEnStock = loteDepositoTemp.get('cantidad');
                cantidadDetalles[value._data.producto.id].loteId = [];
                cantidadDetalles[value._data.producto.id].loteId.push(loteDepositoTemp.get('id'));
              }
            });
          }else{
            console.log(cantidadDetalles);
            error = true;
            errores.push('No existen lotes para el producto "' + value._data.producto.get('descripcion') + '" en el deposito "' + deposito.get('nombre') + '"');
          }
        });
        promises.push(promise);
      });



      Promise.all(promises).then(function(){
        for(var key in cantidadDetalles) {
           console.log(cantidadDetalles[key]);
           console.log("cantidadDetalles[key].hasOwnProperty('cantidadEnStock')" + cantidadDetalles[key].hasOwnProperty('cantidadEnStock'));
           console.log("cantidadDetalles[key].hasOwnProperty('cantidadRequerida')" + cantidadDetalles[key].hasOwnProperty('cantidadRequerida'));
           if(cantidadDetalles[key].hasOwnProperty('cantidadEnStock') && cantidadDetalles[key].hasOwnProperty('cantidadRequerida')){
             console.log("cantidadDetalles[key].cantidadEnStock  " + cantidadDetalles[key].cantidadEnStock);
             console.log("cantidadDetalles[key].cantidadRequerida " + cantidadDetalles[key].cantidadRequerida);
             if(cantidadDetalles[key].cantidadEnStock - cantidadDetalles[key].cantidadRequerida < 0){
               console.log('entraerrorCantidad');
               error = true;
               errores.push('No se dispone de ' + cantidadDetalles[key].cantidadRequerida + ' unidades del producto "' + cantidadDetalles[key].producto.get('descripcion')  + '" en stock, solo se dispone de ' + cantidadDetalles[key].cantidadEnStock +' unidades');
             }
           }
        }
        if (error == true){
          errores.forEach(function(value){
            Bodega.Notification.show('Error', value, Bodega.Notification.ERROR_MSG);
          });
        }else{
            model.set('deposito', deposito);
            model.set('producto', producto);
            model.set('cantidadProduccion', cantidadAProducir);

          Bodega.Utils.disableElement('button[type=submit]');

          if(model.get('isValid')) {
            model.save().then(function(response) {
              // console.log('response');
              // console.log(response._data.id);
            var params = {};
            var downloadParams ={};
            downloadParams.httpMethod = 'GET';
            params.content_type = 'pdf';
            params.produccion_id = response._data.id;
            params.tipo = 'reporte_produccion';
            // Bodega.Notification.show('Descarga.', 'El reporte se descargará.');
            downloadParams.data = params;
            // Bodega.$.fileDownload("/api/v1/producciones", downloadParams);
              // success
              self.transitionToRoute('producciones');
              Bodega.Notification.show('Éxito', 'La produccion se ha guardado.');
              Bodega.Utils.enableElement('button[type=submit]');
            }, function(response){
              Bodega.Utils.enableElement('button[type=submit]');
            });
          }else{
            Bodega.Utils.enableElement('button[type=submit]');
          }
        }

      });


    },


    cancel: function() {
      var model = this.get('model');
      this.transitionToRoute('producciones');
    }
  }

});

//***********************************************************************************************
Bodega.ProduccionEditController = Ember.ObjectController.extend({

  formTitle: 'Editar Tipo de Producto',

  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      Bodega.Utils.disableElement('button[type=submit]');

      if(model.get('isValid')) {
        model.save().then(function(response) {
          //success
          self.transitionToRoute('producciones');
          Bodega.Notification.show('Éxito', 'La producción se ha actualizado.');
          Bodega.Utils.enableElement('button[type=submit]');
        }, function(response) {
          Bodega.Utils.enableElement('button[type=submit]');
        });
      }else{
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },

    cancel: function() {
      this.transitionToRoute('producciones');
    }
  }

});


//***********************************************************************************************
Bodega.ProduccionDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
			$('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        self.transitionToRoute('producciones');
        Bodega.Notification.show('Éxito', 'La produccion se ha eliminado.');

      }, function(){
        Bodega.Notification.show('Error', 'No se pudo eliminar la produccion', Bodega.Notification.ERROR_MSG);
      });
    },

    cancel: function() {
			$('body').removeClass('modal-open');
      this.transitionToRoute('producciones');
    }
  }
});
