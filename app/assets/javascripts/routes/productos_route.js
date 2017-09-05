Bodega.ProductosIndexRoute = Bodega.AuthenticatedRoute.extend({
  queryParams: {
    tratamientos: {
      refreshModel: true
    }
  },
  model: function(params) {
    // queryParams: ['producto'],
    tratamientos = params['tratamientos'];
    params = {}
    if (tratamientos == "true") {
      params.by_tipo_producto = 'T';
    }else {
      params.by_excluye_tipo_producto = 'T';
    }
    params.by_activo = true
    params.by_ultimo_modificado = true
    params.page = 1

    var post = this.store.find('producto', params);
    return post;

  },

  renderTemplate: function(params) {
    tratamientos = params['tratamientos'];
    if (tratamientos=="true") {
      this.render('productos.tratamientos', {
        // controller: 'productosNew'
      });
    }else {
      this.render('productos.index', {
        // controller: 'productosNew'
      });
    }

  },

  setupController: function(controller, model, params) {
    controller.set('model', model);
    controller.set('currentPage', 1);
    controller.set('verPrecioCompra', this.hasPermission('FE_show_precio_compra'));

    var parametroMultimoneda = this.store.find('parametrosEmpresa', { 'by_soporta_multimoneda': true, 'unpaged': true });
    parametroMultimoneda.then(function() {
      if (parametroMultimoneda.objectAt(0)) {
        controller.set('soportaMultimoneda', true);
      } else {
        controller.set('soportaMultimoneda', false);
      }
    });
    if(params.queryParams.tratamientos == 'true'){
      controller.set('staticFilters.by_tipo_producto', 'T');
      controller.set('staticFilters.by_activo', true);
      controller.set('staticFilters.by_ultimo_modificado', true);
      controller.set('staticFilters.by_excluye_tipo_producto', null);
    }else {
      controller.set('staticFilters.by_tipo_producto', null);
      controller.set('staticFilters.by_excluye_tipo_producto', 'T');
      controller.set('staticFilters.by_activo', true);
      controller.set('staticFilters.by_ultimo_modificado', true);
    }
  }
});

Bodega.ProductoRoute = Bodega.AuthenticatedRoute.extend({});


Bodega.ProductoBaseRoute = Bodega.AuthenticatedRoute.extend({
  setupTiposMonedas: function(controller, model){
    var self = this;
    var id = model.get('id');
    if(id){
      var productoRecord = this.store.getById('producto', id);
      var precioRegistrado = productoRecord.get('precio');
    }

    controller.set('precioRegistrado', precioRegistrado);
    controller.set('habilitaEdicionMoneda', true);
    controller.set('habilitaEdicionPrecio', true);


    var parametroMultimoneda = this.store.find('parametrosEmpresa', { 'by_soporta_multimoneda': true, 'unpaged': true });
    parametroMultimoneda.then(function() {
      if (parametroMultimoneda.objectAt(0)) {
        console.log("Seteando multimoneda...");
        controller.set('soportaMultimoneda', true);
      }
    });
    var monedaSeleccionada = model.get('moneda');
    this.store.find('moneda').then(function(response) {
      console.log("Seteando lista de monedas...");
      controller.set('monedas', response);
      if(monedaSeleccionada){
        monedaSeleccionada.then(function(seleccionada) {
          if(seleccionada){
            console.log("Seteando moneda seleccionada...");
            controller.set('monedaRegistrada', seleccionada);
            controller.set('monedaSeleccionada', seleccionada);

          }
        });
      }else{
        console.log("Seteando moneda por default...");
        controller.set('monedaSeleccionada', response.objectAt(0));
        controller.set('monedaRegistrada', response.objectAt(0));
      }
    });

    var especialidad = model.get('especialidad');
    this.store.find('especialidad', { unpaged: true , habilita_consulta: true}).then(function(response) {
      console.log("Seteando lista de especialidades...");
      controller.set('especialidades', response);
      if(especialidad){
        especialidad.then(function(temp) {
          console.log("especialidad Model");
          console.log(temp);
          if(temp){
            controller.set('especialidadSeleccionada', temp);
          }
        })
      }else{
        controller.set('especialidadSeleccionada', response.objectAt(0));
      };
    });


    var tipoProducto = model.get('tipoProducto');
    this.store.find('tipoProducto', { 'unpaged': true }).then(function(response) {
      console.log("Seteando lista de tipos de producto...");
      controller.set('tiposProducto', response);
      if(tipoProducto){
        tipoProducto.then(function(temp) {
          if(temp){
            controller.set('tiposProductoDefault', temp);
            controller.set('tiposProductoSeleccionado', temp);
          }
        })
      }else{
        controller.set('tiposProductoDefault', response.objectAt(0));
        controller.set('tiposProductoSeleccionado', response.objectAt(0));
      };
    });

    var pack = model.get('pack');
    /*if (pack) {
      if (tipoProducto) {
        console.log("Seteando tipoProductoSeleccionado y default..");
        controller.set('tipoProductoSeleccionado', tipoProducto);
        controller.set('tipoProductoDefault', tipoProducto);
      }
    }*/
    console.log("Desabilitando modificación de precio... ");
    console.log("this.hasPermission('FE_modificar_precio')",this.hasPermission('FE_modificar_precio'));
    controller.set('disableModificarPrecio', !this.hasPermission('FE_put_precios'));
  },

  setupCommonProps: function(controller, model) {
    controller.set('model', model);
    controller.set('modelsFileUpload', []);
    controller.set('currentPage', 1);
    this.setupTiposMonedas(controller, model);

    controller.set('productoSeleccionadoSW', null);
    controller.set('descripcionSW', null);
    controller.set('cantidadDetalle', 1);
    controller.set('count', 0);
    console.log('model',model);
    var detalles = model.get('productoDetalles');
    console.log('Detalles: ', detalles);
    detalles.then(function(response){
      console.log("Seteando Detalles: ", response);
      controller.set('detalles', response);

    });

  }

});

Bodega.ProductoEditRoute = Bodega.ProductoBaseRoute.extend({
  model: function(params) {
    return this.modelFor('producto');
  },

  renderTemplate: function() {
    this.render('productos.new', {
      controller: 'productoEdit'
    });
  },

  setupController: function(controller, model) {
    var self = this;
    model.reload().then(function(response){
      self.setupCommonProps(controller, response);
    })
  }
});

Bodega.ProductoDeleteRoute = Bodega.ProductoBaseRoute.extend({
  model: function(params) {
    return this.modelFor('producto');
  },

  renderTemplate: function() {
    this.render('productos.delete', {
      controller: 'productoDelete'
    });
  }
});

Bodega.ProductosNewRoute = Bodega.ProductoBaseRoute.extend({
  model: function() {
    return this.store.createRecord('producto');
  },

  setupController: function(controller, model) {
    this.setupCommonProps(controller, model);
    controller.set('disableModificarPrecio', false);

  }
});
