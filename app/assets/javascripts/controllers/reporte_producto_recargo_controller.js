Bodega.ReporteProductoRecargoIndexController = Ember.ArrayController.extend({
  formTitle: 'Reporte de Productos por Recargo',
    
  actions: {
    search: function() {
             
      var self = this;
      var params = {};
      var downloadParams ={};
      var producto = this.get('descripcionSW'); 
      downloadParams.httpMethod = 'GET';
      params.content_type = 'pdf';
      params.tipo = 'reporte_producto_recargo';
      listaPrecios = this.get('listaPrecios');
      var producto = this.get('descripcionSW');			
      if(this.get('tipoCreditoSeleccionado')){
        params.by_tipo_credito = this.get('tipoCreditoSeleccionado').get('id');
      }
      if(this.get('medioPagoSeleccionado')){
        params.by_medio_pago = this.get('medioPagoSeleccionado').get('id');
      }
      if(this.get('selectedEmpresa')){
        params.empresa = this.get('selectedEmpresa').get('id');
      }
      if(typeof listaPrecios === 'undefined'){
        params.lista_precios = true;
      }else{
        params.lista_precios = !listaPrecios;
      }
      if(!producto){
        params.producto_id = -1;
      }else if(typeof this.get('productoSeleccionadoSW') !== 'undefined'){
        params.producto_id = this.get('productoSeleccionadoSW').get('id');
      }else{
         params.producto_id = -1;
      }
      // if(!producto){
      //   Bodega.Notification.show('Error','Seleccione un producto',Bodega.Notification.ERROR_MSG);}
      // else{
        downloadParams.data = params
        Bodega.Notification.show('Descarga.', 'El reporte se descargará.');
        Bodega.$.fileDownload("/api/v1/recargos", downloadParams);
      // }        
    }
  }
    
});