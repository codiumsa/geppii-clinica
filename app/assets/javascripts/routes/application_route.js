Bodega.ApplicationRoute = Ember.Route.extend(Ember.SimpleAuth.ApplicationRouteMixin, {

  actions: {
      showModal: function(name, content) {
        this.controllerFor(name).send('clear');
        this.controllerFor(name).set('content', content);
        this.render(name, {
          into: 'application',
          outlet: 'modal'
        });
      },
      removeModal: function() {
        this.disconnectOutlet({
          outlet: 'modal',
          parentView: 'application'
        });
      },

      didTransition: function() {
        Ember.run.schedule('afterRender', this, function () {
          var appController = this.controllerFor('application');
      appController.set('containerHeight', Bodega.newHeightWrapper(true));
          });

        Ember.run.later(this, function () {
          var appController = this.controllerFor('application');
      appController.set('containerHeight', Bodega.newHeightWrapper(true));
          }, 2000);

      return true;
      }
    },

    setupController: function(controller, model) {
      //se setean variables porque en el handlebars no se pueden anidar if's e isAuthorized's
      var permisosUsuario = this.get('session').get('permisos');
    permisosUsuario = typeof permisosUsuario === "string" ? permisosUsuario.split(",") : permisosUsuario;
      permisosUsuario = permisosUsuario || [];
    var i = 0;
    var permisoIndexDepositos = false;
    var permisoIndexAjusteInventario = false;
    var permisoIndexPersonas = false;
    var permisoIndexVendedores = false;
    var permisoIndexMonedas = false;
    var permisoIndexCotizaciones = false;
    var permisoIndexSucursales = false;
    var permisoIndexProducciones = false;

    for(i = 0; i < permisosUsuario.length; i++){
      if(permisosUsuario[i] === 'FE_index_depositos'){
        permisoIndexDepositos = true;
      }
      if(permisosUsuario[i] === 'FE_index_ajuste_inventarios'){
        permisoIndexAjusteInventario = true;
      }
      if(permisosUsuario[i] === 'FE_menu_personas'){
        permisoIndexPersonas = true;
      }
      if(permisosUsuario[i] === 'FE_index_vendedores'){
        permisoIndexVendedores = true;
      }
      if(permisosUsuario[i] === 'FE_index_monedas'){
        permisoIndexMonedas = true;
      }
      if(permisosUsuario[i] === 'FE_index_cotizaciones'){
        permisoIndexCotizaciones = true;
      }
      if(permisosUsuario[i] === 'FE_index_sucursales'){
        permisoIndexSucursales = true;
      }
      if(permisosUsuario[i] === 'FE_index_producciones'){
        permisoIndexProducciones = true;
      }
    }
    controller.set('permisoIndexDepositos', permisoIndexDepositos);
    controller.set('permisoIndexPersonas', permisoIndexPersonas);
    controller.set('permisoIndexProducciones',permisoIndexProducciones);
    console.log("    controller.set('permisoIndexProducciones',permisoIndexProducciones);");
    console.log(permisoIndexProducciones);

      var parametros = this.store.find('parametrosEmpresa', {'default_empresa': true, 'unpaged': true});
      parametros.then(function() {
          controller.set('parametros', parametros.objectAt(0));
        if(parametros.objectAt(0).get('soportaCajas')){
          controller.set('noSoportaCajas', false);
        }else{
          controller.set('noSoportaCajas', true);
        }
        if(parametros.objectAt(0).get('permitePromociones')){
          controller.set('permitePromociones', true);
        }else{
          controller.set('permitePromociones', false);
        }
      });

      var parametrosAjusteInventario = this.store.find('parametrosEmpresa', {'by_soporta_ajuste_inventario' : true, 'unpaged': true});
      parametrosAjusteInventario.then(function() {
      if(permisoIndexAjusteInventario && parametrosAjusteInventario.objectAt(0)){
        controller.set('habilitaAjusteInventario', true);
      }
      });

      var parametrosVendedor = this.store.find('parametrosEmpresa', {'by_vendedor_en_venta' : true, 'unpaged': true});

      var parametrosSucursales = this.store.find('parametrosEmpresa', {'by_soporta_sucursales' : true, 'unpaged': true});
      parametrosSucursales.then(function() {
      if(permisoIndexSucursales && parametrosSucursales.objectAt(0)){
        controller.set('habilitaSucursales', true);
      } else {
        controller.set('habilitaSucursales', false);
      }
      });

      parametrosVendedor.then(function() {
      if(permisoIndexVendedores && parametrosVendedor.objectAt(0)){
        controller.set('habilitaVendedores', true);
      }
      });

        var parametroMultimoneda = this.store.find('parametrosEmpresa', {'by_soporta_multimoneda': true, 'unpaged' : true});
      parametroMultimoneda.then(function() {
        if(parametroMultimoneda.objectAt(0) && permisoIndexMonedas){
          controller.set('habilitaSubmenuMonedas', true);
        }
        if(parametroMultimoneda.objectAt(0) && permisoIndexCotizaciones){
          controller.set('habilitaCotizaciones', true);
        }
        if(controller.get('habilitaSubmenuMonedas') || controller.get('habilitaCotizaciones')){
          controller.set('habilitaMonedas', true);
        }
        else{
          controller.set('habilitaMonedas', false);
        }
      });
    }
});
