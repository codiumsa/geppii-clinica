Bodega.ReporteEventoIndexController = Ember.ArrayController.extend({
  formTitle: 'Reporte de Eventos',
  
  eventos: [
                {nombre: "Venta con Monto 0", id: "venta_cero"},
                {nombre: "Cambio en precio de producto", id: "cambio_de_precio"},
                {nombre: "Aplicaciones de descuentos", id: "aplicacion_descuento"}
               ],

  actions: {
    search: function() {
      var self = this;
      var params = {};
      var downloadParams = {};
      downloadParams.httpMethod = 'GET';
      params.content_type = 'pdf';
      params.tipo = 'eventos';

      if(this.get('tipoEventoSeleccionado')) {
        params.by_tipo = this.get('tipoEventoSeleccionado').id;
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

      
      Bodega.Notification.show('Descarga.', 'El reporte se descargará.');
      downloadParams.data = params;
      Bodega.$.fileDownload("/api/v1/eventos", downloadParams);
    }
  }
});