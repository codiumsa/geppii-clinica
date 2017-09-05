Bodega.NoEncontradoRoute = Bodega.AuthenticatedRoute.extend({
  renderTemplate: function() {
    this.render('404', {});
  }
});
