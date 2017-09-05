Bodega.CategoriaOperacionesIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('categoriaOperacion', {page: 1, by_activo: true, con_tipo_operacion:true});
  },
  
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  },

   
});

Bodega.CategoriaOperacionRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.CategoriaOperacionesNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    var record = this.store.createRecord('categoriaOperacion');
    console.log(record);
    return record;
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
    this.store.find('tipoOperacion', {'by_categorizable': true, 'unpaged': true}).then(function(response){ 
        controller.set('tipoOperaciones', response);
        controller.set('tipoOperacionDefault', response.objectAt(0));
    }); 
  }
});

Bodega.CategoriaOperacionEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('categoriaOperacion');
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
    var tipoOperacionSeleccionada = model.get('tipoOperacion');
    tipoOperacionSeleccionada.then(function (response) {
       controller.set('tipoOperacionSeleccionada', response);
    });
    this.store.find('tipoOperacion', {'by_categorizable': true, 'unpaged': true})
      .then(function(response){ 
        controller.set('tipoOperaciones', response);
    });    
  },

  renderTemplate: function() {
    this.render('categoriaOperaciones.new', {
      controller: 'categoriaOperacionEdit'
    });
  }
});

Bodega.CategoriaOperacionDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('categoriaOperacion');
  },

  renderTemplate: function() {
    this.render('categoriaOperaciones.delete', {
      controller: 'categoriaOperacionDelete'
    });
  }
});


