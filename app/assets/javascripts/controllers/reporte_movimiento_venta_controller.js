Bodega.ReporteMovimientoVentaIndexController = Ember.ArrayController.extend({
    
  formTitle: 'Movimiento de Ventas',
    
  actions: {
    search: function() {
             
      var self = this;
      var params = {};
      var downloadParams ={};
      downloadParams.httpMethod = 'GET';
      params.content_type = 'pdf';
      params.tipo = 'movimiento_venta';

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
			
			Bodega.Notification.show('Descarga.', 'El reporte se descargará.');
      downloadParams.data = params;
      Bodega.$.fileDownload("/api/v1/ventas", downloadParams);
               
    }        
  }
    
});