Bodega.ReporteInformacionVoluntariosIndexController = Ember.ArrayController.extend({
  formTitle: 'Reporte de Información de Voluntarios',

  actions: {
    search: function() {
      var self = this;
      var params = {};
      var fechaDespues = this.get('fecha_inicio_despues');
      var fechaAntes = this.get('fecha_inicio_antes');
      var fechaDia = this.get('fecha_inicio_dia');
      var downloadParams ={};
      var colaboradorSeleccionado = this.get('colaboradorSeleccionado');
      var especialidadSeleccionada = this.get('especialidadSeleccionada');

      if (colaboradorSeleccionado != null && this.get('infoColaborador') != '') {
        params.by_colaborador_id = colaboradorSeleccionado.get('id');
      }
      if (especialidadSeleccionada != null && this.get('infoEspecialidad') != '') {
        params.by_especialidad_id = especialidadSeleccionada.get('id');
      }

      downloadParams.httpMethod = 'GET';
      params.by_activo = true;
      params.content_type = 'xls';
      params.report_type = 'informacion_voluntarios';


      if(this.get('fecha_inicio_despues')){
        params.by_fecha_posible_after = this.get ('fecha_inicio_despues');
      }
      if(this.get('fecha_inicio_antes')){
        params.by_fecha_posible_before = this.get ('fecha_inicio_antes');
      }
      if(this.get('fecha_inicio_dia')){
        params.by_fecha_posible_on = this.get ('fecha_inicio_dia');
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
          Bodega.$.fileDownload("/api/v1/colaboradores", downloadParams);
      }
    }
  }
});
