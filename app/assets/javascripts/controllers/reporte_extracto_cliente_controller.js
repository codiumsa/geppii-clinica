Bodega.ReporteExtractoClienteIndexController = Ember.ArrayController.extend({
    
  formTitle: 'Reporte de Extracto de Clientes',
    
  actions: {
    search: function() {
             
      var self = this;
      var params = {};
      var downloadParams ={};
      downloadParams.httpMethod = 'GET';
      params.content_type = 'pdf';
      params.tipo = 'extracto_cliente';
      if(this.get('ruc_cliente')){
        params.by_cliente_ruc = this.get('ruc_cliente');
      }

      if(this.get('selectedSucusal')){
        params.by_sucursal_id = this.get('selectedSucusal').get('id');
      }
      if(this.get('selectedMoneda')){
        params.moneda_id = this.get('selectedMoneda').get('id');
      }
      if(this.get('fecha_inicio_despues')){
        paramas.by_fecha_registro_after = this.get ('fecha_inicio_despues');
      }
      if(this.get('fecha_inicio_antes')){
        paramas.by_fecha_registro_before = this.get ('fecha_inicio_antes');
      }
      if(this.get('fecha_inicio_dia')){
        paramas.by_fecha_registro_on = this.get ('fecha_inicio_dia');
      }


			
			Bodega.Notification.show('Descarga.', 'El reporte se descargará.');
      downloadParams.data = params;
      Bodega.$.fileDownload("/api/v1/ventas", downloadParams);
               
    }        
  }
    
});