Bodega.ReportePacientesIndexController = Ember.ArrayController.extend({
  formTitle: 'Reporte de Pacientes',
  tipoReporte: 'listado',
  esLegajo: false,
  checkTipo: function() {
      tipo = this.get('tipoReporte');
      if (tipo == 'listado') this.set('esLegajo', false);
      else  this.set('esLegajo', true);
  }.observes('tipoReporte'),

  actions: {

    search: function() {
      var self = this;
      var params = {};
      var fechaDespues = this.get('fecha_inicio_despues');
      var fechaAntes = this.get('fecha_inicio_antes');
      var fechaDia = this.get('fecha_inicio_dia');
      var paciente = this.get('pacienteSeleccionado');
      var downloadParams ={};

      downloadParams.httpMethod = 'GET';
      tipo = this.get('tipoReporte');
      if (tipo == 'listado') {
        params.content_type = 'xls';
        params.tipo = 'reporte_listado_pacientes';

        if(this.get('nombre')){
          params.by_nombre = this.get ('nombre');
        }
        if(this.get('apellido')){
          params.by_apellido = this.get ('apellido');
        }

        if(this.get('registrados_despues')){
          params.by_fecha_registro_after = this.get ('registrados_despues');
        }
        if(this.get('registrados_dia')){
          params.by_fecha_registro_on = this.get ('registrados_dia');
        }
        if(this.get('registrados_antes')){
          params.by_fecha_registro_before = this.get ('registrados_despues');
        }
        if(this.get('modificados_despues')){
          params.by_fecha_modificacion_after = this.get ('modificados_despues');
        }
        if(this.get('modificados_dia')){
          params.by_fecha_modificacion_on = this.get ('modificados_dia');
        }
        if(this.get('modificados_despues')){
          params.by_fecha_modificacion_before = this.get ('modificados_despues');
        }
        if(this.get('consultaron_despues')){
          params.by_fecha_consulta_after = this.get ('consultaron_despues');
        }
        if(this.get('consultaron_dia')){
          params.by_fecha_consulta_on = this.get ('consultaron_dia');
        }
        if(this.get('consultaron_despues')){
          params.by_fecha_consulta_before = this.get ('consultaron_despues');
        }
        if(this.get('tratamientoSeleccionado')){
          params.by_tratamiento = this.get('tratamientoSeleccionado')['nombre'];
        }
        if(this.get('productoSeleccionadoSW')){
          params.by_medicamento = this.get('productoSeleccionadoSW').get('id');
        }
      } else {
        params.content_type = 'pdf';
        params.tipo = 'reporte_legajo_paciente';

        if(this.get('pacienteSeleccionado')){
          params.by_id = this.get('pacienteSeleccionado').get('id');
        }
      }


      if(fechaAntes && fechaDia){
        Bodega.Notification.show('Error','Seleccione un rango de fechas válido',Bodega.Notification.ERROR_MSG);
      }else if(fechaDespues && fechaDia){
        Bodega.Notification.show('Error','Seleccione un rango de fechas válido',Bodega.Notification.ERROR_MSG);
      }else if(fechaAntes && fechaDia && fechaDespues){
        Bodega.Notification.show('Error','Seleccione un rango de fechas válido',Bodega.Notification.ERROR_MSG);
      }else if (fechaDespues && fechaAntes && (fechaDespues.getTime()>fechaAntes.getTime())){
        Bodega.Notification.show('Error','Seleccione un rango de fechas válido',Bodega.Notification.ERROR_MSG);
      }else if (tipo != 'listado' && paciente === undefined) {
        Bodega.Notification.show('Error','Elija un paciente',Bodega.Notification.ERROR_MSG);
      }
      else{
          downloadParams.data = params
          Bodega.Notification.show('Descarga.', 'El reporte se descargará.');
          Bodega.$.fileDownload("/api/v1/pacientes", downloadParams);
      }
    }

  }

});
