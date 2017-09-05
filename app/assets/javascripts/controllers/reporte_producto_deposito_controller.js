Bodega.ReporteProductoDepositoIndexController = Ember.ArrayController.extend({
  formTitle: 'Reporte de Productos por Depósito',
    
  actions: {
    search: function() {
             
      var self = this;
      var params = {};
      var downloadParams ={};
      downloadParams.httpMethod = 'GET';
      params.content_type = 'pdf';
      
			if(this.get('selectedDeposito')){
        params.by_deposito_id = this.get('selectedDeposito').get('id');
      }
      if (!this.get('incluyeCero')){
          params.by_excluye_fuera_de_stock = !this.get('incluyeCero');
      }
      if(this.get('selectedCategoria')){
        params.by_categoria_id = this.get('selectedCategoria').get('id');
      }

      downloadParams.data = params
			Bodega.Notification.show('Descarga.', 'El reporte se descargará.');
      Bodega.$.fileDownload("/api/v1/producto_depositos", downloadParams);
               
    }
  }
    
});