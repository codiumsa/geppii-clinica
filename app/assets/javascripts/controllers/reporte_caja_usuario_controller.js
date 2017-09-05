Bodega.ReporteCajaUsuarioIndexController = Ember.ArrayController.extend({
  formTitle: 'Reporte de Movimientos de Caja por Usuario',
    
  actions: {
    search: function() {
      var self = this;
      var params = {};
      var downloadParams ={};
      downloadParams.httpMethod = 'GET';
      params.content_type = 'pdf';
      params.tipo = 'reporte_caja_usuario';
      params.by_usuario = self.get("selectedUsuario").id;

      var fechaDespues = this.get('fecha_despues');
      var fechaAntes = this.get('fecha_antes');
      var fechaDia = this.get('fecha_dia');

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
        Bodega.Notification.show('Descarga.', 'El reporte se descargará.');
        downloadParams.data = params;
        Bodega.$.fileDownload("/api/v1/movimientos", downloadParams);
      }        
    }
  }
});