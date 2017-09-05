Bodega.ReporteListadoVoluntariosIndexRoute = Bodega.AuthenticatedRoute.extend({
  setupController: function(controller, model) {

  this.store.find('especialidad', { unpaged: true , habilita_consulta: true}).then(function(response) {
    controller.set('especialidades', response);
  });

  this.store.find('tipoColaborador', { unpaged: true }).then(function(response) {
      controller.set('tipoColaboradores', response);
    });
  }
});

Bodega.ReporteListadoVoluntarios= Bodega.AuthenticatedRoute.extend({});
