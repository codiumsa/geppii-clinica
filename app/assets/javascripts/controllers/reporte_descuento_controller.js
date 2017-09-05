Bodega.ReporteDescuentoIndexController = Ember.ArrayController.extend({
    
  formTitle: 'Descuentos en Ventas',

  enters: 2,

  descuentos: [{nombre: "Cualquier descuento", id: "tiene_descuento"},
                {nombre: "Descuento Redondeo", id: "tiene_descuento_redondeo"},
                {nombre: "Descuento en Detalles", id: "tiene_descuento_detalle"},
                {nombre: "Descuento en Detalles con Promo", id: "tiene_descuento_detalle_con_promo"},
                {nombre: "Descuento en Detalles sin Promo", id: "tiene_descuento_detalle_sin_promo"}
               ],

  tipoDescuentoDefault: {nombre: "Cualquier descuento", id: "tiene_descuento"},
  
  contarEnters: function() {
      //console.log("VentasBaseController->action->contarEnters");
      var count = this.get('count');
      if (count === undefined) {
          count = 0;
          this.set('count', count);
      }

      count = count + 1;

      if (count >= this.get('enters')) {
          this.set('count', 0);
          //this.send('generarReporte');
      } else {
          this.set('count', count);
      }
  },

  resetCount: function () {
    var codigoBarra = this.get('codigoBarra');
    var descripcionProducto = this.get('descripcionSW');
    if (codigoBarra === "" || descripcionProducto === "") {
        this.set('count', 0);
        this.set('productoSeleccionadoSW', undefined);
    }
  }.observes('codigoBarra','descripcionSW'),

  cargarProducto: function() {
    var self = this;
    var codigo = this.get('codigoBarra');
    this.set('cargaProductoFin',false);
    if (codigo){
      self.store.find('producto', {'codigo_barra' : codigo}).then(function(response){ // si se encuentra el producto por codigo se actualiza la descripcion
        if(response.content.length == 0){
          self.set('productoSeleccionadoSW', undefined);
          self.set('descripcionSW',undefined);
          self.set('count',0);
        }else{
          //$('#productoDescripcion').focus();
          self.set('productoSeleccionadoSW', response.content[0]);
          self.set('descripcionSW',response.content[0]._data.descripcion);   
          self.set('count',1);
        }
      });
    }
  },

 loadFromSearchWidget: function () {
      //console.log("VentasBaseController->loadFromSearchWidget");
          //console.log("VentasBaseController->loadFromSearchWidget agregandoDetalle false");
          var productoSeleccionado = this.get('productoSeleccionadoSW');
          console.log('codigos');
          console.log(productoSeleccionado.get('codigoBarra'));
          console.log(this.get('codigoBarra'));

          if (productoSeleccionado && productoSeleccionado.get('id') !== null && productoSeleccionado.get('codigoBarra') != this.get('codigoBarra')) {
            console.log('entraif');
              var codigoBarraSW = productoSeleccionado.get('codigoBarra');
              this.set('codigoBarra', codigoBarraSW);
          }
  }.observes('productoSeleccionadoSW'),
    
  actions: {
    search: function() {
             
      var self = this;
      var params = {};
      var downloadParams = {};
      downloadParams.httpMethod = 'GET';
      params.content_type = 'pdf';
      params.tipo = 'descuento_venta';
      var tipoDescuentoSeleccionado = this.get('tipoDescuentoSeleccionado');
      params[tipoDescuentoSeleccionado.id] = true;
      params['tipo_descuento'] = tipoDescuentoSeleccionado.id;

      if(this.get('selectedSucursal')){
        params.by_sucursal_id = this.get('selectedSucursal').get('id');
      }
      if(this.get('monedaSeleccionada')){
        params.by_moneda_id = this.get('monedaSeleccionada').get('id');
        params.moneda_nombre = this.get('monedaSeleccionada').get('nombre')
      }
      if(this.get('fecha_inicio_despues')){
        params.by_fecha_registro_after = this.get ('fecha_inicio_despues');
      }

      if(this.get('fecha_inicio_antes')){
        params.by_fecha_registro_before = this.get ('fecha_inicio_antes');
      }

      if(this.get('fecha_inicio_dia')){
        params.by_fecha_registro_on = this.get ('fecha_inicio_dia');
      }

      if(this.get('selectedUsuario')){
        params.by_usuario_id = this.get('selectedUsuario').get('id');
      }

      if(this.get('productoSeleccionadoSW')) {
        params.by_producto_id = this.get('productoSeleccionadoSW').get('id');
      }
			
			Bodega.Notification.show('Descarga.', 'El reporte se descargará.');
      downloadParams.data = params;
      Bodega.$.fileDownload("/api/v1/ventas", downloadParams);
               
    }        
  }
    
});