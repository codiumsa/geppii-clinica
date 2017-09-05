Bodega.ReportePreciosVentaIndexController = Ember.ArrayController.extend({
  formTitle: 'Reporte de Precios de Venta',
  enters: 2,

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
          this.send('generarReporte');
      } else {
          this.set('count', count);
      }
  },

  resetCount: function () {
    var codigoBarra = this.get('codigoBarra');
    var descripcionProducto = this.get('descripcionSW');
    if (codigoBarra === "" || descripcionProducto === "") {
        this.set('count', 0);
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
           $('#productoDescripcion').focus();
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
    generarReporte: function() {
      var self = this;
      var params = {};
      var downloadParams ={};
      var producto = this.get('descripcionSW'); 
      downloadParams.httpMethod = 'GET';
      params.content_type = 'pdf';
      params.tipo = 'precios_venta';
      precioCompra = this.get('precioCompra');

      if(this.get('selectedEmpresa')){
        params.empresa = this.get('selectedEmpresa').get('id');
      }
      if(typeof precioCompra === 'undefined'){
        params.precio_compra = true;
      }else{
        params.precio_compra = !precioCompra;
      }
      if(typeof this.get('productoSeleccionadoSW') !== 'undefined'){
        params.producto_id = this.get('productoSeleccionadoSW').get('id');
      }
      if(!producto || (typeof this.get('productoSeleccionadoSW') == 'undefined')){
        Bodega.Notification.show('Error','Seleccione un producto',Bodega.Notification.ERROR_MSG);}
      else{
        downloadParams.data = params
        Bodega.Notification.show('Descarga.', 'El reporte se descargará.');
        Bodega.$.fileDownload("/api/v1/ventas", downloadParams);
     }
    }
  }  
});