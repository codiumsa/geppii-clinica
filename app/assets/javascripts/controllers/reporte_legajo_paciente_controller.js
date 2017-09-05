Bodega.ReporteLegajoPacienteIndexController = Ember.ArrayController.extend({
  formTitle: 'Reporte de Legajo de Paciente',

  actions: {
    search: function() {

      var self = this;
      var params = {};
      var downloadParams ={};
      downloadParams.httpMethod = 'GET';
      params.content_type = 'pdf';
      params.tipo = 'reporte_legajo_paciente';
      console.log(this.get('pacienteSeleccionado'.infoPaciente));
      if(!this.get('pacienteSeleccionado') || this.get('infoPaciente') == ''){
        Bodega.Notification.show('Error', 'Seleccione un paciente', Bodega.Notification.ERROR_MSG);
        return;
      }

      params.paciente_id = this.get('pacienteSeleccionado.id');

      Bodega.Notification.show('Descarga.', 'El reporte se descargará.');
      downloadParams.data = params;
      // Bodega.$.fileDownload("/api/v1/pacientes", downloadParams);
      Bodega.Utils.printPdf('/api/v1/pacientes/', params);

    }
  }

});
