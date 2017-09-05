Bodega.ReportePatrocinadoresIndexRoute = Bodega.AuthenticatedRoute.extend({
  setupController: function(controller, model) {
    controller.set('tipoPatrocinadores', ["Mantenimiento", "Seguimiento", "Recuperación"]);
  }
});

Bodega.ReportePatrocinadores = Bodega.AuthenticatedRoute.extend({});