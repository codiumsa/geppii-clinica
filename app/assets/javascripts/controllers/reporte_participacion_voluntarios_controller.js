Bodega.ReporteParticipacionVoluntariosIndexController = Ember.ArrayController.extend({
  formTitle: 'Reporte de Participación de Voluntarios',

  eventosObserver: function (){
    console.log('entras');
    var eventoSeleccionado = this.get('eventoSeleccionado');
    if (eventoSeleccionado == 'Cursos') {
      this.set('eventoCurso',true);
      this.set('eventoViaje',false);
      this.set('eventoCampanha',false);
      this.set('campanhaSeleccionada',null);
      this.set('viajeSeleccionado',null);
    }else if (eventoSeleccionado == 'Viajes') {
      this.set('eventoCurso',false);
      this.set('eventoViaje',true);
      this.set('eventoCampanha',false);
      this.set('cursoSeleccionado',null);
      this.set('campanhaSeleccionada',null);
    }else if (eventoSeleccionado == 'Campañas') {
      this.set('eventoCurso',false);
      this.set('eventoViaje',false);
      this.set('eventoCampanha',true);
      this.set('cursoSeleccionado',null);
      this.set('viajeSeleccionado',null);
    }else if (eventoSeleccionado == 'Todos') {
      this.set('eventoCurso',false);
      this.set('eventoViaje',false);
      this.set('eventoCampanha',false);
      this.set('cursoSeleccionado',null);
      this.set('viajeSeleccionado',null);
      this.set('campanhaSeleccionada',null);
    }
  }.observes('eventoSeleccionado'),

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
      var viajeSeleccionado = this.get('viajeSeleccionado');
      var cursoSeleccionado = this.get('cursoSeleccionado');
      var campanhaSeleccionada = this.get('campanhaSeleccionada');
      var eventoCurso = this.get('eventoCurso');
      var eventoViaje = this.get('eventoViaje');
      var eventoCampanha = this.get('eventoCampanha');

      if (eventoCurso) {
        if (cursoSeleccionado != null && this.get('infoCurso') != '') {
          params.curso_id = cursoSeleccionado.get('id');
        }else {
          params.curso_id = -1;
        }
      }
      else if (eventoViaje) {
        if (viajeSeleccionado != null && this.get('infoViaje') != '') {
          params.viaje_id = viajeSeleccionado.get('id');
        }else {
          params.viaje_id = -1;
        }
      }
      else if (eventoCampanha) {
        if (campanhaSeleccionada != null && this.get('infoCampanha') != '') {
          params.campanha_id = campanhaSeleccionada.get('id');
        }else {
          params.campanha_id = -1;
        }
      }

      downloadParams.httpMethod = 'GET';
      params.content_type = 'xls';
      params.report_type = 'participacion_voluntarios';

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
