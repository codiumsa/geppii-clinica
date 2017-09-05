Bodega.OperacionesIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('operacion', {page: 1});
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
    var self = this;

    controller.set('muestraSaldo', self.get('session').get('permisos').indexOf('FE_show_cajas_saldo') > 0);
   //console.log('muestraSaldo' + self.get('session').get('permisos').indexOf('FE_show_cajas_saldo') > 0);


    self.store.find('movimiento').then(function(response){ 
      controller.set('movimientos', response);
    });
    
  }

});

Bodega.OperacionesNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    if (params.queryParams.abierta) {
        console.log("caja abierta ref= " +params.queryParams.ref);
        Bodega.Notification.show('Atención', Bodega.Messages.mensajeRequiereApertura, 
                                     Bodega.Notification.WARNING_MSG);
    }

    var model = this.store.createRecord('operacion');
    if (params.queryParams.transition) {
      model.transition = params.queryParams.transition;
    }

    return model;
  },

  setupController: function(controller, model) {
    var self = this;
    controller.set('model', model);
    if (model.transition) {
      controller.set('transitionAfter', model.transition);
    }
    var cajasUsuario = this.store.find('caja', {by_usuario: true});
    var cajasSucursal = this.store.find('caja', {by_sucursal: true});
    var tiposOperacion = this.store.find('tipoOperacion', {by_manual_permitido: true});
    var cajas = self.store.find('caja', {by_cajas_permitidas: true}); 

    controller.set('muestraSaldo', self.get('session').get('permisos').indexOf('FE_show_cajas_saldo') > 0);
    controller.set('cajasquery', cajas);
    cajasUsuario.then(function() {
      console.log("cajasUsuario.then -> Obteniendo cajas de usuario: " + cajasUsuario.objectAt(0).get('codigo'));
      controller.set('cajaUsuario', cajasUsuario.objectAt(0));
      cajasSucursal.then(function() {
        console.log("cajasSucursal.then -> Obteniendo cajas de sucursal." + cajasSucursal.objectAt(0).get('codigo'));
        controller.set('cajaSucursal', cajasSucursal.objectAt(0));

        tiposOperacion.then(function() {
          console.log("tiposOperacion.then -> Obteniendo tipos de operacion");
          controller.set('tiposOperacion', tiposOperacion);
          controller.set('tipoOperacionDefault', tiposOperacion.objectAt(0));
          controller.set('tipoOperacionAnterior',  tiposOperacion.objectAt(0));
          controller.set('tipoOperacionSeleccionada', tiposOperacion.objectAt(0));
        });
      });
      
    });
    controller.set('store', this.store);
  }
});

Bodega.OperacionDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('operacion');
  },

  renderTemplate: function() {
    this.render('operaciones.delete', {
      controller: 'operacionDelete'
    });
  }
});