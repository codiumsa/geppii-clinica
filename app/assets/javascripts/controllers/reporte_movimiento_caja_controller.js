Bodega.ReporteMovimientoCajaIndexController = Ember.ArrayController.extend({
  formTitle: 'Reporte de Movimientos por Caja',
    
  actions: {
    search: function() {
      var self = this;
      var params = {};
      var downloadParams ={};
      downloadParams.httpMethod = 'GET';
      params.content_type = 'pdf';
      params.tipo = 'reporte_movimientos_caja';

      console.log(this.get('selectedCaja'));
			var fechaDespues = this.get('fecha_despues');
      var fechaAntes = this.get('fecha_antes');
      var fechaDia = this.get('fecha_dia');

      if(this.get('selectedCaja')){
        params.by_caja_id = this.get('selectedCaja').get('id');
      }
      if(this.get('fecha_antes')){
        params.by_fecha_before = this.get('fecha_antes');
      }
      if(this.get('fecha_despues')){
        params.by_fecha_after = this.get('fecha_despues');
      }
      if(this.get('fecha_dia')){
        params.by_fecha_on = this.get('fecha_dia');
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
        Bodega.Notification.show('Éxito', 'Creado correctamente');
        downloadParams.data = params;
        Bodega.$.fileDownload("/api/v1/movimientos", downloadParams);
      }        
    }
  }
});