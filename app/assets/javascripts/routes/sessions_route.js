Bodega.SessionsNewRoute = Ember.Route.extend({
  model: function() {
    return Ember.Object.create();
  },

  actions: {
    sessionAuthenticationFailed: function (error) {
      console.log('error ' + error);
      this.controller.set('errorMessage', error.errors);
    },
  },

  setupController: function (controller, model) {
    controller.set('model', model);

    var codigoSucursalDefault;
    var parametros = this.store.find('parametrosEmpresa', {'by_soporta_caja_impresion' : true, 'unpaged': true});
    parametros.then(function() {
      controller.set('parametros', parametros.objectAt(0));
      if (parametros.objectAt(0)) {
        var sucursalDefault = parametros.objectAt(0).get('sucursalDefault');
        sucursalDefault.then(function() {
          codigoSucursalDefault = sucursalDefault.get('codigo');
        });
      }
    });

    var sucDef = this.store.find('sucursal', {'by_codigo' : codigoSucursalDefault});
		var self = this;
    sucDef.then(function (response) {			
      controller.set('sucursales', sucDef.objectAt(0));
      controller.set('sucursalDefault', sucDef.objectAt(0));
			if (controller.get('sucursalDefault') === undefined || controller.get('sucursalDefault') === null){
				self.store.find('sucursal', {'unpaged' : true}).then(function (response) {
					controller.set('sucursales', response);
					controller.set('sucursalDefault', response.objectAt(0));
					//console.log(controller.get('sucursalDefault'));

				});
			}
    });
    //console.log(controller.get('sucursalDefault'));
   
    this.store.find('cajaImpresion').then(function (response) {
      controller.set('cajasImpresion', response);
      controller.set('cajaImpresionDefault', response.objectAt(0));
    });
      
    
  }
});
