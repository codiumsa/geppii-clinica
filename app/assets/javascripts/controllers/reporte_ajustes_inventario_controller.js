Bodega.ReporteAjustesInventarioIndexController = Ember.ArrayController.extend({
  formTitle: 'Reporte de Ajustes de Inventario',

  actions: {
    search: function() {

      var self = this;
      var params = {};
      var fechaDespues = this.get('fecha_despues');
      var fechaAntes = this.get('fecha_antes');
      var fechaDia = this.get('fecha_dia');
      var downloadParams = {};
      var producto = this.get('descripcionSW');
      downloadParams.httpMethod = 'GET';
      params.content_type = 'pdf';
      params.tipo = 'reporte_ajuste_inventarios';

     if(this.get('productoSeleccionadoSW') != null && producto != null && producto != ''){
        params.by_producto = this.get('productoSeleccionadoSW').get('id');
     }
      if(fechaDespues){
        params.by_fecha_after = fechaDespues;
      }
      if(fechaAntes){
        params.by_fecha_before = fechaAntes;
      }
      if(fechaDia){
        params.by_fecha_on = fechaDia;
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
          Bodega.$.fileDownload("/api/v1/ajuste_inventarios", downloadParams);
      }



    }
  }

});
