Bodega.ReporteParticipacionVoluntariosIndexRoute = Bodega.AuthenticatedRoute.extend({
  setupController: function(controller, model) {

  this.store.find('especialidad', { unpaged: true , habilita_consulta: true}).then(function(response) {
    controller.set('especialidades', response);
  });
  controller.set('eventos',['Todos','Cursos','Viajes','Campañas']);
  // controller.set('eventoSeleccionado','Todos');
  controller.set('eventoCurso',false);
  controller.set('eventoViaje',false);
  controller.set('eventoCampanha',false);


  }
});

Bodega.ReporteParticipacionVoluntarios= Bodega.AuthenticatedRoute.extend({});
