Bodega.CursosIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('curso', {page: 1});
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.CursoRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.CursoEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('curso');
  },

  renderTemplate: function() {
    this.render('cursos.new', {
      controller: 'cursoEdit'
    });
  },

  setupController: function(controller, model) {
    controller.set('model', model);

    var cursos = model.get('cursoColaboradores');
    console.log('cursos', cursos);
    cursos.then(function(response){
      console.log("Seteando cursos: ", response);
      controller.set('colaboradores', response);
    });

  }
});

Bodega.CursoDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('curso');
  },

  renderTemplate: function() {
    this.render('cursos.delete', {
      controller: 'cursoDelete'
    });
  }
});

Bodega.CursosNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    var record = this.store.createRecord('curso');
    return record;
  },

  setupController: function(controller, model) {
    controller.set('model', model);

    var cursos = model.get('cursoColaboradores');
    console.log('cursos', cursos);
    cursos.then(function(response){
      console.log("Seteando cursos: ", response);
      controller.set('colaboradores', response);
    });

  }
});
