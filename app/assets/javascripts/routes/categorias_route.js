Bodega.CategoriasIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('categoria', {page:1});
  },
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.CategoriaRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.CategoriaEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('categoria');
  },

  renderTemplate: function() {
    this.render('categorias.new', {
      controller: 'categoriaEdit'
    });
  }
});

Bodega.CategoriaDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('categoria');
  },

  renderTemplate: function() {
    this.render('categorias.delete', {
      controller: 'categoriaDelete'
    });
  }
});

Bodega.CategoriasNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.createRecord('categoria');
  }
});