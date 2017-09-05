Bodega.ReporteValoracionInventarioIndexController = Ember.ArrayController.extend({
  formTitle: 'Reporte de Valoracion del Inventario',

  actions: {
    search: function() {

      var self = this;
      var params = {};
      params.content_type = 'pdf';
      params.tipo = 'reporte_valoracion_inventario';
      if(this.get('depositoSeleccionado')){
        params.by_deposito = this.get('depositoSeleccionado').get('id');
      }

      console.log(params)
      var downloadParams ={};
      downloadParams.httpMethod = 'GET';
      downloadParams.data = params;


      console.log("Se notifica de la descarga...");
      Bodega.Notification.show('Descarga.', 'El reporte se descargará.');
      console.log("Se llama al servicio");
      
      Bodega.$.fileDownload("/api/v1/lote_depositos", downloadParams);
    }
  }

});
