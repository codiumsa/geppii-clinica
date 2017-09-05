Bodega.UsuariosIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('usuario', {page: 1});
  },
  
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.UsuarioRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.UsuariosNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    var record = this.store.createRecord('usuario');
    console.log(record);
    return record;
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('nuevoUsuario', true);
    controller.set('changePass', true)
  }
});

Bodega.UsuarioEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('usuario');
  },

  renderTemplate: function() {
    this.render('usuarios.new', {
      controller: 'usuarioEdit'
    });
  }

});

Bodega.UsuarioDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('usuario');
  },

  renderTemplate: function() {
    this.render('usuarios.delete', {
      controller: 'usuarioDelete'
    });
  }
});