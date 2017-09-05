Bodega.ReporteInformacionVoluntariosIndexRoute = Bodega.AuthenticatedRoute.extend({
  setupController: function(controller, model) {

  this.store.find('especialidad', { unpaged: true , habilita_consulta: true}).then(function(response) {
    controller.set('especialidades', response);
  });
  }
});

Bodega.ReporteInformacionVoluntarios= Bodega.AuthenticatedRoute.extend({});
