Bodega.ReporteGananciasIndexController = Ember.ArrayController.extend({
    
  formTitle: 'Reporte de Ganancias',
    
  actions: {
    search: function() {
             
      var self = this;
      var params = {};
      var downloadParams ={};
      downloadParams.httpMethod = 'GET';
      params.content_type = 'pdf';
      params.tipo_reporte = 'ganancias';
      
      if(this.get('fecha_registro_antes')){
        params.by_fecha_registro_before = this.get('fecha_registro_antes');
      }
      if(this.get('fecha_registro_despues')){
        params.by_fecha_registro_after = this.get('fecha_registro_despues');
      }
      if(this.get('fecha_registro_dia')){
        params.by_fecha_registro_on = this.get('fecha_registro_dia');
      }

      if(this.get('selectedSucusal')){
        params.by_sucursal_id = this.get('selectedSucusal').get('id');
      }

      console.log(params);

      downloadParams.data = params
      Bodega.$.fileDownload("/api/v1/ventas", downloadParams);        
    }
        
        
  }
    
});