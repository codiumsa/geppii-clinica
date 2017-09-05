Bodega.CajasIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('caja', {page: 1});
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
    controller.set('puedeBorrar', this.hasPermission('FE_delete_cajas'));
    controller.set('puedeEditar', this.hasPermission('FE_put_cajas'));
    controller.set('muestraSaldo', this.get('session').get('permisos').indexOf('FE_show_cajas_saldo') > 0);
    console.log(this.get('session').get('permisos').indexOf('FE_show_cajas_saldo') > 0);

  }
});

Bodega.CajaRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.CajaEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('caja');
  },

  renderTemplate: function() {
    this.render('cajas.new', {
      controller: 'cajaEdit'
    });
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    // var sucursal = model.get('sucursal');
    var tipo = model.get('tipoCaja');
    var tipoDefault = {id: tipo};


    controller.set('tipoDefault', tipoDefault);
    // if (sucursal) {
    //   sucursal.then(function (response) {
    //     controller.set('sucursalDefault', response);
    //     controller.set('sucursalSeleccionada', response);
    //   });
    // }

    this.store.find('usuario',{'tiene_caja_asignada':0}).then(function(response){ 
      controller.set('usuarios', response);
      controller.set('usuarioDefault', response.objectAt(0));
    });

    // this.store.find('sucursal').then(function(response){ 
    //   controller.set('sucursales', response);
    // });
  }
});

Bodega.CajaDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('caja');
  },

  renderTemplate: function() {
    this.render('cajas.delete', {
      controller: 'cajaDelete'
    });
  }
});

Bodega.CajasNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.createRecord('caja');
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    console.log("llega");
    this.store.find('usuario',{'tiene_caja_asignada':0}).then(function(response){ 
      controller.set('usuarios', response);
      controller.set('usuarioDefault', response.objectAt(0));
    });

    this.store.find('empresa').then(function(response){
      controller.set('empresas',response);
      controller.set('empresaDefault', response.objectAt(0));
      controller.set('empresaSeleccionada', response.objectAt(0));
    });


  }


});