Bodega.ReporteCuentasCobrarIndexController = Ember.ArrayController.extend({
    
  formTitle: 'Reporte de Cuentas Por Cobrar',
    
  actions: {
    search: function() {
             
      var self = this;
      var params = {};
      var downloadParams = {};
      downloadParams.httpMethod = 'GET';
      params.content_type = 'pdf';

      var fechaDespues = this.get('fecha_venta_despues');
      var fechaAntes = this.get('fecha_venta_antes');
      var fechaDia = this.get('fecha_venta_dia');

      var fechaVencimientoDespues = this.get('fecha_vencimiento_despues');
      var fechaVencimientoAntes = this.get('fecha_vencimiento_antes');
      var fechaVencimientoDia = this.get('fecha_vencimiento_dia');

      var fecha_venta = false;
      var fecha_vencimiento = false;
      
			if(this.get('nombre_cliente')){
        params.by_cliente_nombre = this.get('nombre_cliente');
      }
      
      if(this.get('apellido_cliente')){
        params.by_cliente_apellido = this.get('apellido_cliente');
      }
      
      if(this.get('ruc_cliente')){
        params.by_cliente_ruc = this.get('ruc_cliente');
      }
			
      if(this.get('selectedSucusal')){
        params.by_sucursal_id = this.get('selectedSucusal').get('id');
      }
			if(this.get('selectedEmpresa')){
        params.by_empresa_id = this.get('selectedEmpresa').get('id');
      }
      if(this.get('nro_factura')){
        params.by_nro_factura = this.get('nro_factura');
      }

      if(this.get('fecha_venta_antes')){
        params.by_fecha_venta_before = this.get('fecha_venta_antes');
      }
      if(this.get('fecha_venta_despues')){
        params.by_fecha_venta_after = this.get('fecha_venta_despues');
      }
      if(this.get('fecha_venta_dia')){
        params.by_fecha_venta_on = this.get('fecha_venta_dia');
      }
      if(this.get('fecha_cobro_antes')){
        params.by_fecha_cobro_before = this.get('fecha_cobro_antes');
      }
      if(this.get('fecha_cobro_despues')){
        params.by_fecha_cobro_after = this.get('fecha_cobro_despues');
      }
      if(this.get('fecha_cobro_dia')){
        params.by_fecha_cobro_on = this.get('fecha_cobro_dia');
      }
      if(this.get('fecha_vencimiento_antes')){
        params.by_fecha_vencimiento_before = this.get('fecha_vencimiento_antes');
      }
      if(this.get('fecha_vencimiento_despues')){
        params.by_fecha_vencimiento_after = this.get('fecha_vencimiento_despues');
      }
      if(this.get('fecha_vencimiento_dia')){
        params.by_fecha_vencimiento_on = this.get('fecha_vencimiento_dia');
      }
      if(this.get('total_menor')){
        params.by_total_lt = this.get('total_menor');
      }
      if(this.get('total_igual')){
        params.by_total_eq = this.get('total_igual');
      }
      if(this.get('total_mayor')){
        params.by_total_gt = this.get('total_mayor');
      }
			
      if(this.get('anulados')){
        params.by_venta_anulada = true;
      } else {
        params.by_venta_anulada = false;
      }
			params.by_cancelado = false;


      if(fechaAntes && fechaDia){
        Bodega.Notification.show('Error','Seleccione un rango de fechas de venta válido',Bodega.Notification.ERROR_MSG);
      }else if(fechaDespues && fechaDia){
        Bodega.Notification.show('Error','Seleccione un rango de fechas de venta válido',Bodega.Notification.ERROR_MSG);
      }else if(fechaAntes && fechaDia && fechaDespues){
        Bodega.Notification.show('Error','Seleccione un rango de fechas de venta válido',Bodega.Notification.ERROR_MSG);
      }else if (fechaDespues && fechaAntes && (fechaDespues.getTime()>fechaAntes.getTime())){
        Bodega.Notification.show('Error','Seleccione un rango de fechas de venta válido',Bodega.Notification.ERROR_MSG);
      }else{
        fecha_venta = true;
      }    

      if(fechaVencimientoAntes && fechaVencimientoDia){
        Bodega.Notification.show('Error','Seleccione un rango de fechas de vencimiento válido',Bodega.Notification.ERROR_MSG);
      }else if(fechaVencimientoDespues && fechaVencimientoDia){
        Bodega.Notification.show('Error','Seleccione un rango de fechas de vencimiento válido',Bodega.Notification.ERROR_MSG);
      }else if(fechaVencimientoAntes && fechaVencimientoDia && fechaVencimientoDespues){
        Bodega.Notification.show('Error','Seleccione un rango de fechas de vencimiento válido',Bodega.Notification.ERROR_MSG);
      }else if (fechaVencimientoDespues && fechaVencimientoAntes && (fechaVencimientoDespues.getTime()>fechaVencimientoAntes.getTime())){
        Bodega.Notification.show('Error','Seleccione un rango de fechas de vencimiento válido',Bodega.Notification.ERROR_MSG);
      }else{
        fecha_vencimiento = true;   
      }   

      if(fecha_venta && fecha_vencimiento){
        Bodega.Notification.show('Descarga.', 'El reporte se descargará.');
        downloadParams.data = params;
        Bodega.$.fileDownload("/api/v1/venta_cuotas", downloadParams);
      }        
    }
        
        
  }
    
});