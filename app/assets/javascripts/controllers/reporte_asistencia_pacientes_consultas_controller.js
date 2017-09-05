Bodega.ReporteAsistenciaPacientesConsultasIndexController = Ember.ArrayController.extend({
  formTitle: 'Reporte de Asistencia de Pacientes a Consultas',

  actions: {
    search: function() {
      var self = this;
      var params = {};
      var fechaDespues = this.get('fecha_inicio_despues');
      var fechaAntes = this.get('fecha_inicio_antes');
      var fechaDia = this.get('fecha_inicio_dia');
      var downloadParams ={};
      var pacienteSeleccionado = this.get('pacienteSeleccionado');
      var especialidadSeleccionada = this.get('especialidadSeleccionada');

      if (pacienteSeleccionado != null && this.get('infoPaciente') != '') {
        params.by_paciente_id = pacienteSeleccionado.get('id');
      }
      if (especialidadSeleccionada != null && this.get('infoEspecialidad') != '') {
        params.by_especialidad_id = especialidadSeleccionada.get('id');
      }

      downloadParams.httpMethod = 'GET';
      params.content_type = 'xls';
      params.tipo = 'reporte_asistencia_consultas';


      if(this.get('fecha_inicio_despues')){
        params.by_fecha_agenda_after = this.get ('fecha_inicio_despues');
      }
      if(this.get('fecha_inicio_antes')){
        params.by_fecha_agenda_before = this.get ('fecha_inicio_antes');
      }
      if(this.get('fecha_inicio_dia')){
        params.by_fecha_agenda_on = this.get ('fecha_inicio_dia');
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
          Bodega.$.fileDownload("/api/v1/consultas", downloadParams);
      }
    }
  }
});
