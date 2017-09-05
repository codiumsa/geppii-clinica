Bodega.PromocionesIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function () {
    return this.store.find('promocion', {page: 1});
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);

    this.store.find('promocion').then(function(response){
      controller.set('promociones', response);
    });
  }
});

Bodega.PromocionRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    console.log(params);
    return this._super(params);
  }
});

Bodega.PromocionEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('promocion');
  },

  renderTemplate: function() {
    this.render('promociones.new', {
      controller: 'promocionEdit'
    });

  },

  setupController: function(controller, model) {
    controller.set('model', model);
    var detalles = model.get('detalle');
    controller.set('detNuevo', this.store.createRecord('promocionProducto')); 
    detalles.then(function(response){
      console.log("Detalles de la promoción editada: ");
      console.log(response);
      response.forEach(function(detalle){
          detalle.get('moneda').then();
      });
      controller.set('detalles', response);
    });
    
    this.store.find('tarjeta', {unpaged: true}).then(function(response){
      controller.set('tarjetas', response);
    });
    var tarjeta = model.get('data.tarjeta');
    
    if(tarjeta) {
      controller.set('tarjetaSeleccionada', tarjeta);
    }

    var parametros = this.store.find('parametrosEmpresa', {unpaged: true});
    parametros.then(function() {
        var parametro = parametros.objectAt(0);

        if (parametro) {
            controller.set('parametros', parametro);
        } 
    });

    controller.set('detalleReadOnly', !($.inArray('FE_put_promociones', this.get('session.permisos').split(",")) > -1));
    controller.set('detalleNotDelete', !($.inArray('FE_delete_promociones', this.get('session.permisos').split(",")) > -1));

    console.log('detalleReadOnly = ' + controller.get('detalleReadOnly'));
    console.log('detalleNotDelete = ' + controller.get('detalleNotDelete'));
  }

});

Bodega.PromocionDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('promocion');
  },

  renderTemplate: function() {
    this.render('promociones.delete', {
      controller: 'promocionDelete'
    });
  }
});

Bodega.PromocionesNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.createRecord('promocion');
  },
  
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('ckTemporal', true);
    
    model.get('detalle').then(function(response){
      controller.set('detalles', response);
    });

    controller.set('detNuevo', this.store.createRecord('promocionProducto'));
    
    this.store.find('tarjeta', {unpaged: true}).then(function(response){
      controller.set('tarjetas', response);
    });

    var parametros = this.store.find('parametrosEmpresa', {unpaged: true});
    parametros.then(function() {
        var parametro = parametros.objectAt(0);

        if (parametro) {
            controller.set('parametros', parametro);
        } 
    });

    controller.set('detalleReadOnly', !($.inArray('FE_put_promociones', this.get('session.permisos').split(",")) > -1));
    controller.set('detalleNotDelete', !($.inArray('FE_delete_promociones', this.get('session.permisos').split(",")) > -1));

    console.log('detalleReadOnly = ' + controller.get('detalleReadOnly'));
    console.log('detalleNotDelete = ' + controller.get('detalleNotDelete'));
  }
});