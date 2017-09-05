Bodega.ReporteListadoVoluntariosIndexController = Ember.ArrayController.extend({
  formTitle: 'Listado de Voluntarios',

  actions: {
    search: function() {
      var self = this;
      var params = {};
      var downloadParams ={};
      var colaboradorSeleccionado = this.get('colaboradorSeleccionado');
      var especialidadSeleccionada = this.get('especialidadSeleccionada');
      var tipoColaborador = this.get('tipoColaboradorSeleccionado');

      if (colaboradorSeleccionado != null && this.get('infoColaborador') != '') {
        params.by_colaborador_id = colaboradorSeleccionado.get('id');
      }
      if (especialidadSeleccionada != null && this.get('infoEspecialidad') != '') {
        params.by_especialidad_id = especialidadSeleccionada.get('id');
      }
      if (tipoColaborador) {
        params.by_tipo_colaborador_id = this.get('tipoColaboradorSeleccionado').get('id');
      }

      downloadParams.httpMethod = 'GET';
      params.by_activo = true;
      params.content_type = 'xls';
      params.report_type = 'listado_voluntarios';

      
      downloadParams.data = params
      Bodega.Notification.show('Descarga.', 'El reporte se descargará.');
      Bodega.$.fileDownload("/api/v1/colaboradores", downloadParams);

    }
  }
});
