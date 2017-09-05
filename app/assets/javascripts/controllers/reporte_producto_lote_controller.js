Bodega.ReporteProductoLoteIndexController = Ember.ArrayController.extend({
  formTitle: 'Reporte de Lotes por Producto',

  actions: {
    search: function() {

      var self = this;
      var params = {};
      var fechaDespues = this.get('fecha_inicio_despues');
      var fechaAntes = this.get('fecha_inicio_antes');
      var fechaDia = this.get('fecha_inicio_dia');
      var downloadParams ={};
      var producto = this.get('descripcionSW');
      downloadParams.httpMethod = 'GET';
      params.content_type = 'pdf';
      params.tipo = 'reporte_producto_lotes';

        console.log(this.get('productoSeleccionadoSW'));
        console.log(producto);


     if(this.get('productoSeleccionadoSW') != null && producto != null && producto != ''){
        params.by_producto = this.get('productoSeleccionadoSW').get('id');
     }
      if(this.get('fecha_inicio_despues')){
        params.by_fecha_vencimiento_after = this.get ('fecha_inicio_despues');
      }
      if(this.get('fecha_inicio_antes')){
        params.by_fecha_vencimiento_before = this.get ('fecha_inicio_antes');
      }
      if(this.get('fecha_inicio_dia')){
        params.by_fecha_vencimiento_on = this.get ('fecha_inicio_dia');
      }
      if(fechaAntes && fechaDia){
        Bodega.Notification.show('Error','Seleccione un rango de fechas válido',Bodega.Notification.ERROR_MSG);
      }else if(fechaDespues && fechaDia){
        Bodega.Notification.show('Error','Seleccione un rango de fechas válido',Bodega.Notification.ERROR_MSG);
      }else if(fechaAntes && fechaDia && fechaDespues){
        Bodega.Notification.show('Error','Seleccione un rango de fechas válido',Bodega.Notification.ERROR_MSG);
      }else if (fechaDespues && fechaAntes && (fechaDespues.getTime()>fechaAntes.getTime())){
        Bodega.Notification.show('Error','Seleccione un rango de fechas válido',Bodega.Notification.ERROR_MSG);
      }else{
          downloadParams.data = params
          Bodega.Notification.show('Descarga.', 'El reporte se descargará.');
          Bodega.$.fileDownload("/api/v1/lotes", downloadParams);
      }



    }
  }

});
