Bodega.CategoriaClientesIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('categoriaCliente', {page: 1});
  },
  
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  },

   
});

Bodega.CategoriaClienteRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.CategoriaClientesNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    var record = this.store.createRecord('categoriaCliente');
    console.log(record);
    return record;
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
   // controller.set('nuevoUsuario', true);
    //controller.set('changePass', true)
  }
});

Bodega.CategoriaClienteEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('categoriaCliente');
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
   
  },

  renderTemplate: function() {
    this.render('categoriaClientes.new', {
      controller: 'categoriaClienteEdit'
    });
  }
});

Bodega.CategoriaClienteDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('categoriaCliente');
  },

  renderTemplate: function() {
    this.render('categoriaClientes.delete', {
      controller: 'categoriaClienteDelete'
    });
  }
});


