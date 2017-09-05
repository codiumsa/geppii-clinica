Bodega.ReporteVentasMedioPagoIndexController = Ember.ArrayController.extend({
  formTitle: 'Reporte de Ventas por Medio de pago',
    
  actions: {
    search: function() {
             
      var self = this;
      var params = {};
      var downloadParams ={};
      downloadParams.httpMethod = 'GET';
      params.content_type = 'pdf';
      params.tipo = 'reporte_venta_medio_pago';

      var fechaDespues = this.get('fecha_inicio_despues');
      var fechaAntes = this.get('fecha_inicio_antes');
      var fechaDia = this.get('fecha_inicio_dia');
      // if(this.get('medioPagoSeleccionado')){
      //   params.by_medio_pago = this.get('medioPagoSeleccionado').get('codigo');
      // }
      if(this.get('selectedEmpresa')){
        params.by_empresa_id = this.get('selectedEmpresa').get('id');
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
        Bodega.$.fileDownload("/api/v1/ventas", downloadParams);
      }        
    }
  }
    
});