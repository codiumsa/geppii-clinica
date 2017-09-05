Bodega.ReporteVentasIndexController = Ember.ArrayController.extend({

  formTitle: 'Reporte de Salidas',

  actions: {
    search: function() {

      var self = this;
      var params = {};
      var downloadParams ={};
      downloadParams.httpMethod = 'GET';
      params.content_type = 'pdf';
      params.tipo = 'reporte_ventas';

      var fechaDespues = this.get('fecha_despues');
      var fechaAntes = this.get('fecha_antes');
      var fechaDia = this.get('fecha_dia');
      if(this.get('nombre_cliente')){
        params.by_cliente_nombre = this.get('nombre_cliente');
      }

      if(this.get('apellido_cliente')){
        params.by_cliente_apellido = this.get('apellido_cliente');
      }

      if(this.get('ruc_cliente')){
        params.by_cliente_ruc = this.get('ruc_cliente');
      }

      if(this.get('nombre_vendedor')){
        params.by_vendedor_nombre = this.get('nombre_vendedor');
      }

      if(this.get('apellido_vendedor')){
        params.by_cliente_apellido = this.get('apellido_vendedor');
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

      if(this.get('tipoSalidaSeleccionada')){
        params.by_tipo_salida = this.get('tipoSalidaSeleccionada').get('codigo');
      }

      if(this.get('selectedTipoPago')){

        if(this.get('selectedTipoPago') == 'Contado'){
          params.by_credito = false;
        }

        if(this.get('selectedTipoPago') == 'Crédito'){
          params.by_credito = true;
        }
      }

      if(this.get('selectedTipoCredito')){
        params.by_tipo_credito_id = this.get('selectedTipoCredito').get('id');
      }

      if(this.get('fecha_antes')){
        params.by_fecha_registro_before = this.get('fecha_antes');
      }

      if(this.get('fecha_despues')){
        params.by_fecha_registro_after = this.get('fecha_despues');
      }

      if(this.get('fecha_dia')){
        params.by_fecha_registro_on = this.get('fecha_dia');
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

      if(this.get('codigoBarra')){
        params.by_codigo_barra = this.get('codigoBarra');
      }

      if(this.get('anulados')){
        params.by_anulados = true;
      } else {
        params.by_anulados = false;
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
