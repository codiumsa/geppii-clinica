Bodega.ReporteExistenciaInventarioIndexController = Ember.ArrayController.extend({
  formTitle: 'Reporte de Existencia del Inventario',

  actions: {
    search: function() {

      var self = this;
      var params = {};
      var downloadParams ={};
      downloadParams.httpMethod = 'GET';
      params.content_type = 'pdf';
      params.tipo = 'reporte_existencia_inventario';
      if(this.get('depositoSeleccionado') && this.get('nombre') != ''){
        params.by_deposito = this.get('depositoSeleccionado.').get('id');
      }
      Bodega.Notification.show('Descarga.', 'El reporte se descargará.');
      downloadParams.data = params;
      Bodega.$.fileDownload("/api/v1/lote_depositos", downloadParams);
    }
  }

});
