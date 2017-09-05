Bodega.SucursalesIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return  this.store.find('sucursal', {page: 1, by_activo: true});
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.SucursalRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.SucursalEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    var modelo = this.modelFor('sucursal');
    modelo.set('crearDeposito', false);
    return modelo;
  },

  renderTemplate: function() {
    this.render('sucursales/new', {
      controller: 'sucursalEdit'
    });
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    console.log(model.get('vendedor'));
    this.store.find('vendedor', {'by_activo' : true}).then(function(response) {
        controller.set('vendedores', response);
        response.forEach(function(temp) {
          if(temp.get('id') == model.get('vendedor').get('id')){
            controller.set('vendedorSeleccionado', temp);
          }
        });
    });
   var parametros = this.store.find('parametrosEmpresa', {'default_empresa': true, 'unpaged': true});
    parametros.then(function() {
        controller.set('parametros', parametros.objectAt(0));
        if(controller.get('parametros').soportaCajas){
          this.store.find('caja',{'sucursal' : model.get('id'), 'by_tipo_caja' : 'O'}).then(function(response){
            controller.set('cajas', response);
          });
          this.store.find('caja', {'sucursal' : model.get('id'), 'by_tipo_caja' : 'P'}).then(function(response) {
              controller.get('cajas').addObject(response.objectAt(0))
              controller.set('cajaDefault', response.objectAt(0));
              controller.set('selectedCaja', response.objectAt(0));
          });
        }

    });

  }
});

Bodega.SucursalDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('sucursal');
  },

  renderTemplate: function() {
    this.render('sucursales.delete', {
      controller: 'sucursalDelete'
    });
  },


});

Bodega.SucursalesNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.createRecord('sucursal');
  },

  setupController: function(controller, model) {
    controller.set('model', model);

    this.store.find('vendedor', {'by_activo' : true}).then(function(response) {
        controller.set('vendedores', response);
        controller.set('vendedorSeleccionado', response.objectAt(0));
    });
  }
});