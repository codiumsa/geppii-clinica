Bodega.ProductosIndexController = Ember.ArrayController.extend(Bodega.mixins.Pageable, Bodega.mixins.Filterable, {
  resource: 'producto',
  queryParams: ['tratamientos'],
  // staticFilters: {
  //   by_tipo_producto: null,
  //   by_activo: null,
  //   by_ultimo_modificado: null,
  //   by_excluye_tipo_producto: null
  // },

  perPage: 15,
  actions: {
    irALoteDepositos: function(id) {
      this.transitionToRoute('loteDepositos', {
        queryParams: {
          producto: id
        }
      });
    }
  }
});

//*****************************BASE Controller******************************************
Bodega.ProductosBaseController = Ember.ObjectController.extend({

  ivas: [10, 5, 0],

  selectedIva: null,

  categoriaSerializer: Bodega.CategoriaSerializer,

  enters: 2,

  especialidadProcedimiento: function() {
    var tipoProducto = this.get('tiposProductoSeleccionado');
    console.log(tipoProducto);
    if (tipoProducto !== undefined && (tipoProducto.get('especialidad') || tipoProducto.get('tratamiento'))) {
      this.set('hablitarEspecialidadProcedimiento', true);
    }
  }.observes('tiposProductoSeleccionado'),

  actions: {
    guardarNuevaCategoriaProducto: function(cat, producto) {

      var newCategoriaProducto = this.store.createRecord('categoriaProducto', {
        producto: producto,
        categoria: cat
      });
      newCategoriaProducto.save();

    },



    borrarCategoriaProducto: function() {
      //Traer lista de Categorias Productos relacionadas y borrar.
      var parametros = {};
      var model = this.get('model');
      parametros.by_producto = model.get('id');
      var catProducto = this.store.find('categoriaProducto', parametros);
      catProducto.then(function(response) {
        catProducto.forEach(function(response) {
          response.deleteRecord();
          response.save();
        });
      });
    },

    checkEsPack: function() {
      var model = this.get('model');
      console.log('holaa');
      if (!model.get('pack')) {
        model.set('producto', undefined);
        model.set('cantidad', undefined);
      }
    }.observes('pack'),



    loadFromSearchWidget: function() {
      console.log("ProductosBaseController->loadFromSearchWidget");
      if (!this.get('agregandoDetalle')) {
        console.log("ProductosBaseController->loadFromSearchWidget agregandoDetalle false");
        var productoSeleccionado = this.get('productoSeleccionadoSW');
        if (productoSeleccionado && productoSeleccionado.get('id') !== null) {
          this.loadProducto();
        }
      }
    }.observes('productoSeleccionadoSW'),

    agregarDetalle: function() {
      console.log("Agregando detalle");
      var producto = this.get('productoSeleccionadoSW');
      var self = this;
      var detalle = this.store.createRecord('productoDetalle');
      detalle.set('cantidad', this.get('cantidadDetalle'));
      detalle.set('producto', producto);

      // console.log(producto);
      // console.log(producto == undefined);
      // if(producto == undefined || this.get('cantidadDetalle') == undefined){
      //   Bodega.Notification.show('Error', 'Debe elegir un producto y una cantidad.', Bodega.Notification.ERROR_MSG);
      //   return;
      // }

      var detalles = this.get('detalles');
      if (detalles) {
        cantidadDetalles = detalles.content.length;
      } else {
        console.log("No existen los detalles!!");
        return;
      }



      if (detalle.get('producto') && detalle.get('cantidad')) {
        this.set('agregandoDetalle', true);
        detalles.addRecord(detalle);
        console.log("Detalle agregado: ", detalle);
        this.set('agregandoDetalle', false);
        this.send('clearProducto');
        console.log('Producto agregado, lista: ', this.get('detalles'));
        $("#producto").focus();
        this.set('count', 0);
      } else {
        console.log('No está cargado el detalle nuevo.... ERROR');
      }
    },

    loadProducto: function() {
      console.log('ProductosBaseController->loadproducto');
      console.log('productoSeleccionadoSW', this.get('productoSeleccionadoSW'));
      if (this.get('productoSeleccionadoSW')) {
        console.log('Producto Cargado: ', this.get('productoSeleccionadoSW'));
        $("#cantidadDetalle").focus();
      } else {
        $("#producto").focus();
      }
    },

    borrarDetalleProducto: function(detalle) {
      //console.log("VentasBaseController->action->borrarDetalle detalle:"+detalle);
      ////console.log("borrarDetalle %o", detalle);
      var self = this;

      this.get('detalles').removeRecord(detalle);

      // this.get('controllers.application').set('containerHeight', Bodega.newHeightWrapper());

      // self.set('permitirAgregarMedios', false);
      //detalle.deleteRecord();
      ////console.log("borrarDetalle", this.get('indice'));
    },

    clearProducto: function() {
      console.log("ProductosBaseController->clearProducto: " + !this.get('agregandoDetalle'));
      if (!this.get('agregandoDetalle')) {
        this.set('cantidadDetalle', 1);
        this.set('descripcionSW', null);
        this.set('productoSeleccionadoSW', null);
      }
    }.observes('producto'),

    clearProductoTemp: function() {
      console.log('clearProductoTemp');
      console.log("this.get('productoSeleccionadoSW')");
      console.log(this.get('productoSeleccionadoSW'));
      if (!this.get('productoSeleccionadoSW')) {
        this.set('descripcionSW', null);
      }
    },

    contarEnters: function() {
      console.log("ProductosBaseController->action->contarEnters");
      var count = this.get('count');
      if (count === undefined) {
        count = 0;
        this.set('count', count);
      }

      count = count + 1;

      if (count >= this.get('enters')) {
        this.set('count', 0);
        this.send('agregarDetalle');
      } else {
        this.set('count', count);
      }
    },

    resetCount: function() {
      //console.log("VentasBaseController->action->resetCount");
      var count = this.get('codigoBarra');
      if (count === "") {
        this.set('count', 0);
      }
    }.observes('producto'),

    save: function() {
      var self = this;
      var model = this.get('model');
      var modelsFileUpload = this.get('modelsFileUpload');
      //Setear el iva
      var iva = this.get('selectedIva');
      model.set('iva', iva);
      model.set('precioPromedio', model.get('precioCompra'));
      var errors = model.get('errors');
      var detallesProducto = this.get('detallesProducto');
      var tipoProductoSeleccionado = this.get('tiposProductoSeleccionado');
      var moneda = this.get('monedaSeleccionada');
      model.set('moneda', moneda);

      console.log("Model.detalles: ",  model.get('productoDetalles'));
      console.log("Controller.detalles: ",  self.get('detalles'));

      // model.get('productoDetalles').then(function (result) {
      //   var detalles = self.get('detalles');
      //   //result.pushObjects(detalles);
      // })

      console.log("A PERSISTIR: ", model.get('productoDetalles'));

      Bodega.Utils.disableElement('button[type=submit]');

      if (tipoProductoSeleccionado.get('set') && model.get('productoDetalles').get('length') == 0) {
        Bodega.Notification.show('Error', 'Debe ingresar por lo menos un producto para el SET', Bodega.Notification.ERROR_MSG);
        return;
      }

      /*if (model.get('producto') && errors.has('producto')) {
        // eliminamos los mensajes de error relacionados al producto padre ya que
        // el atributo dejó de ser undefined
        errors.remove('producto');
      }*/

      if (model.get('isValid')) {
        model.set('tipoProducto', self.get('tiposProductoSeleccionado'));
        if (self.get('tiposProductoSeleccionado').get('servicio')) {
          model.set('pack', false);
          model.set('producto', null);
          model.set('cantidad', null);
          model.set('stockMinimo', 0);
        } else if (self.get('tiposProductoSeleccionado').get('productoOsi')) {
          model.set('codigoExterno', self.get('codigoExterno'));
          model.set('codigoLocal', self.get('codigoLocal'));
          model.set('desripcionExterna', self.get('desripcionExterna'));
          model.set('desripcionLocal', self.get('desripcionLocal'));
        } else {
          if (self.get('tiposProductoSeleccionado').get('procedimiento')) {
            model.set('esProcedimiento', self.get('procedimiento'));
          }
          if (self.get('tiposProductoSeleccionado').get('especialidad')) {
            model.set('especialidad', self.get('especialidadSeleccionada'));
          }
        }
        console.log(model);

        model.save().then(function(product) {
          //guardar foto si se seleccionó
          console.log("productoRetornado: ", product);
          // self.store.push('producto',product);
          if (modelsFileUpload.length > 0) {
            modelsFileUpload[0].uploadFile(product.get('id'), 'productos', 'foto').then(function(data) {
              console.log(data);
              product.set('urlFoto', data.url);
            });
          }
          self.transitionToRoute('productos').then(function() {
            Bodega.Notification.show('Éxito', 'El producto se ha guardado.');
            Bodega.Utils.enableElement('button[type=submit]');
          });

        }, function(response) {
          // error
          Bodega.Utils.enableElement('button[type=submit]');
        });
      } else {
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },
  } //end actions

});

//******************************ProductoNew****************************************************
Bodega.ProductosNewController = Bodega.ProductosBaseController.extend({


  formTitle: 'Nuevo Producto',

  habilitaEdicionMoneda: true,
  habilitaEdicionPrecio: true,
  productoDetalles: {},

  actions: {



    cancel: function() {
      var model = this.get('model');
      model.deleteRecord();
      this.transitionToRoute('productos');
    },
  }
});

//***********************************************************************************************
Bodega.ProductoEditController = Bodega.ProductosBaseController.extend({

  formTitle: 'Editar Producto',
  habilitaEdicionMoneda: true,
  habilitaEdicionPrecio: true,

  editMoneda: function() {
    console.log('EN EDIT MONEDA');
    var precioForm = this.get('precio');
    var precioRegistrado = this.get('precioRegistrado');

    if (precioRegistrado) {
      if (precioRegistrado === Number(precioForm)) {
        this.set('habilitaEdicionMoneda', true);
      } else {
        this.set('habilitaEdicionMoneda', false);
      }
    } else {
      this.set('habilitaEdicionMoneda', true);
      console.log('HABILITA EDICION MONEDA TRUE');
    }

  }.observes('precio'),

  editPrecio: function() {
    var monedaSeleccionada = this.get('monedaSeleccionada');
    var monedaRegistrada = this.get('monedaRegistrada');

    if (monedaRegistrada) {
      if (monedaSeleccionada === monedaRegistrada) {
        this.set('habilitaEdicionPrecio', true);
      } else {
        this.set('habilitaEdicionPrecio', false);
      }
    } else {
      this.set('habilitaEdicionPrecio', true);
    }

  }.observes('monedaSeleccionada'),

  actions: {

    cancel: function() {
      this.transitionToRoute('productos');
    },

    contarEnters: function() {
      var count = this.get('count');
      if (count === undefined) {
        count = 0;
        this.set('count', count);
      }

      count = count + 1;

      if (count >= this.get('enters')) {
        this.set('count', 0);
        this.send('save');
      } else {
        this.set('count', count);
      }
    },

    /*save: function() {
      var self = this;
      var model = this.get('model');
      //Setear el iva
      var iva = this.get('selectedIva');
      model.set('iva', iva);
      var modelsFileUpload = this.get('modelsFileUpload');
      var errors = model.get('errors');

      var moneda = this.get('monedaSeleccionada');
      model.set('moneda', moneda);

      Bodega.Utils.disableElement('button[type=submit]');

      if (model.get('producto') && errors.has('producto')) {
        // eliminamos los mensajes de error relacionados al producto padre ya que
        // el atributo dejó de ser undefined
        errors.remove('producto');
      }

      model.set('tipoProducto', self.get('tiposProductoSeleccionado'));
      if (!model.get('tipoProducto').get('medicamento')) {
        model.set('codigoExterno', null);
        model.set('codigoLocal', null);
        model.set('descripcionExterna', null);
        model.set('descripcionLocal', null);
      } else if (model.get('tipoProducto').get('medicamento')) {
        model.set('codigoExterno', self.get('codigoExterno'));
        model.set('codigoLocal', self.get('codigoLocal'));
        model.set('desripcionExterna', self.get('desripcionExterna'));
        model.set('desripcionLocal', self.get('desripcionLocal'));
      } else if (self.get('tiposProductoSeleccionado').get('servicio')) {
        model.set('pack', false);
        model.set('producto', null);
        model.set('cantidad', null);
        model.set('stockMinimo', 0);
      }



      if (model.get('isValid')) {
        model.save().then(function() {
          //guardar foto si se seleccionó
          if (modelsFileUpload.length > 0) {
            modelsFileUpload[0].uploadFile(model.get('id')).then(function(data) {
              console.log(data);
              model.set('urlFoto', data.url);
            });
          }
          self.transitionToRoute('productos').then(function() {
            Bodega.Notification.show('Éxito', 'El producto se ha actualizado.');
            Bodega.Utils.enableElement('button[type=submit]');
          });

        }, function() {
          // error
          Bodega.Utils.enableElement('button[type=submit]');
        });
      } else {
        Bodega.Utils.enableElement('button[type=submit]');
      }
    }*/
  }
});


//***********************************************************************************************
Bodega.ProductoDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
      $('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        Bodega.Notification.show('Éxito', 'El producto se ha eliminado.');
        self.transitionToRoute('productos');
      });
    },

    cancel: function() {
      $('body').removeClass('modal-open');
      this.transitionToRoute('productos');
    }
  }
});
