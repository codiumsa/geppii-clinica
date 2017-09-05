Bodega.ReporteCandidaturaTratamientosIndexController = Ember.ArrayController.extend({
  formTitle: 'Reporte de Candidaturas',

  changedMediante: function() {
    if (!this.get('medianteSeleccionado')) {
      return;
    }
    if (this.get('medianteSeleccionado').descripcion === "Clínica") {
      this.set("medianteClinica", true);
    } else {
      this.set("medianteClinica", false);
    }
    if (this.get('medianteSeleccionado').descripcion === "Misión") {
      this.set("medianteMision", true);
    } else {
      this.set("medianteMision", false);
    }
  }.observes('medianteSeleccionado'),

  actions: {
    search: function() {
      var self = this;
      var params = {};
      var fechaDespues = this.get('fecha_inicio_despues');
      var fechaAntes = this.get('fecha_inicio_antes');
      var fechaDia = this.get('fecha_inicio_dia');
      var downloadParams ={};
      var medianteSeleccionado = this.get('medianteSeleccionado');
      var campanhaSeleccionada = this.get('campanhaSeleccionada');
      if (medianteSeleccionado.descripcion === 'Clínica') {
        params.by_excluye_campanhas = true;
      }else {
        if(campanhaSeleccionada != null && campanhaSeleccionada.get('descripcion') != null){
          params.by_incluye_campanhas = true;
          params.by_campanha_id = this.get('campanhaSeleccionada').get('id');
        }
      }
      downloadParams.httpMethod = 'GET';
      params.content_type = 'pdf';
      params.tipo = 'reporte_candidaturas';


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
          Bodega.$.fileDownload("/api/v1/candidaturas", downloadParams);
      }



    }
  }

});
