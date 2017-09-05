Bodega.ReporteViajesIndexController = Ember.ArrayController.extend({
    formTitle: 'Reporte de Viajes',

    actions: {
    search: function() {

      var self = this;
      var params = {};
      var fechaDespues = this.get('fecha_despues');
      var fechaAntes = this.get('fecha_antes');
      var fechaDia = this.get('fecha_dia');
      var voluntario = this.get('colaboradorSeleccionado');
      var lugar = this.get('lugar');
      var downloadParams = {};
      downloadParams.httpMethod = 'GET';
      params.content_type = 'pdf';
      params.tipo = 'reporte_viajes';

      if(fechaDespues){
        params.by_fecha_after = fechaDespues;
      }
      if(fechaAntes){
        params.by_fecha_before = fechaAntes;
      }
      if(fechaDia){
        params.by_fecha_on = fechaDia;
      }
      if(voluntario) {
          params.by_colaborador_id = this.get('colaboradorSeleccionado').get('id');
      }
      if(lugar) {
          params.by_lugar = this.get('lugar');
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
          Bodega.$.fileDownload("/api/v1/viajes", downloadParams);
      }



    }
  }
});