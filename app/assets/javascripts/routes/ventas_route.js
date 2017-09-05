Bodega.VentaRoute = Bodega.AuthenticatedRoute.extend({});


Bodega.VentasIndexRoute = Bodega.AuthenticatedRoute.extend({
  queryParams: {
    tipo_salida: {
      refreshModel: true
    }
  },

  model: function(params) {
    tipo_salida = params['tipo_salida'];

    params = {}
    params.page = 1
    if (tipo_salida != null)
      params.by_tipo_salida = tipo_salida;
    return this.store.find('venta',  params );
  },

  setupController: function(controller, model, params) {
    console.log('Seteando parametros de acuerdo al query param tipo_salida: ' + params.queryParams.tipo_salida);
    controller.set('model', model);
    controller.set('currentPage', 1);
    controller.set('tipo_salida', params.queryParams.tipo_salida)
    var self = this;

    if(params.queryParams.tipo_salida == 'clientes'){
      controller.set('staticFilters.by_tipo_salida', 'clientes');
    }else if (params.queryParams.tipo_salida == 'pacientes') {
      controller.set('staticFilters.by_tipo_salida', 'pacientes');
    }else if (params.queryParams.tipo_salida == 'consultorio') {
      controller.set('staticFilters.by_tipo_salida', 'consultorio');
    }else if (params.queryParams.tipo_salida == 'campañas') {
      controller.set('staticFilters.by_tipo_salida', 'campañas');
    }else if (params.queryParams.tipo_salida == 'misiones') {
      controller.set('staticFilters.by_tipo_salida', 'misiones');
    }else if (params.queryParams.tipo_salida == 'donaciones')  {
      controller.set('staticFilters.by_tipo_salida', 'donaciones');
    }
    var parametrosImei = self.store.find('parametrosEmpresa', { 'by_imei_en_venta_detalle': true, 'unpaged': true });
    parametrosImei.then(function() {
      var parametro = parametrosImei.objectAt(0);

      if (parametro) {
        controller.set('mostrarImei', true);
      } else {
        controller.set('mostrarImei', false);
      }
    });

    var parametrosUsoInterno = self.store.find('parametrosEmpresa', { 'by_soporta_uso_interno': true, 'unpaged': true });
    parametrosUsoInterno.then(function() {
      var parametro = parametrosUsoInterno.objectAt(0);

      if (parametro) {
        controller.set('soportaUsoInterno', true);
      } else {
        controller.set('soportaUsoInterno', false);
      }
    });


  }
});


Bodega.VentaDuplicarRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('venta');
  },

  renderTemplate: function() {
    /*
    this.render('ventas.new', {
        controller: 'ventaDuplicar'
    });
    */
    this.transitionTo('ventas.new', { queryParams: { ref: this.modelFor('venta').get('id') } });
  }
});

Bodega.VentaEditRoute = Bodega.RequiereCajaAbiertaRoute.extend({
  queryParams: {
    ref: { replace: true },
    tipo_salida: { replace: true }
  },

  model: function(params) {
    console.log('VentasEditRoute', params);
    return this.modelFor('venta');
  },

  renderTemplate: function() {
    this.render('ventas.new', {
      controller: 'ventaEdit'
    });

  },

  setupController: function(controller, model, params) {
    console.log('VentaEditRoute.setupController', params.queryParams.tipo_salida);
    controller.set('model', model);
    controller.set('productoSeleccionado', null);
    controller.set('editando', true);
    var self = this;
    controller.set('nombreCliente', model.get('nombreCliente'));
    var tipoSalida = params.queryParams.tipo_salida;
    if (controller.get('nombreCliente')) {
      controller.set('clienteExistente', false);
    } else {
      controller.set('clienteExistente', true);
    }

    var detalles = model.get('ventaDetalles');
    var cliente = model.get('cliente');
    var garante = model.get('garante');
    if (garante) {
      garante.then(function(response) {
        controller.set('rucGarante', response.get('ruc'));
      });
    }

    detalles.then(function(response) {
      response.get('content').forEach(function(d) {
        var cotizacion = d.get('cotizacion');

        if (cotizacion) {
          cotizacion.then(function(c) {
            var subtotalCotizado = d.get('precio') * d.get('cantidad');

            if (d.get('multiplicarCotizacion')) {
              subtotalCotizado *= d.get('montoCotizacion');
            } else {
              subtotalCotizado /= d.get('montoCotizacion');
            }

            if (d.get('descuento')) {
              subtotalCotizado -= d.get('descuento');
            }

            if (model.get('moneda').get('redondeo')) {
              subtotalCotizado = Math.round(subtotalCotizado, 0);
            } else {
              subtotalCotizado = subtotalCotizado.toFixed(2);
            }
            d.set('subtotalCotizado', subtotalCotizado);
          });
        } else {
          d.set('subtotalCotizado', d.get('subtotal'));
        }
      });
      controller.set('detalles', response.get('content'));

    });

    if (model.get('credito')) {
      var tipoCredito = model.get('tipoCredito');

      if (tipoCredito) {
        tipoCredito.then(function(response) {
          controller.set('tipoCreditoSeleccionado', response);
        });
      }
      controller.set('edicionCredito', true);
    }

    var sucursal = model.get('sucursal');
    var labelActualizar = "";
    controller.set('labelActualizar', labelActualizar);

    var parametros = self.store.find('parametrosEmpresa', { 'by_sucursal': sucursal.id, 'unpaged': true });
    parametros.then(function() {
      var parametro = parametros.objectAt(0);
      if (parametro) {
        console.log("parametro");

        if (parametro.get('soportaImpresionFacturaVenta')) {
          labelActualizar = "e Imprimir";
          controller.set('labelActualizar', labelActualizar);
        }
        console.log('tipoSalida');
        console.log(tipoSalida);
        if(tipoSalida == "Consultorio"){
          controller.set('esDonacion',false);
          controller.set('esCampanha',false);
          controller.set('esMision',false);
          controller.set('esCliente',false);
          controller.set('esPaciente',false);
          controller.set('esConsultorio',true);

        }else if(tipoSalida == "Campañas"){
          controller.set('esMision',false);
          controller.set('esDonacion',false);
          controller.set('esCampanha',true);
          controller.set('esConsultorio',false);
          controller.set('esCliente',false);

        }else if(tipoSalida == "Clientes"){

          controller.set('esDonacion',false);
          controller.set('esCampanha',false);
          controller.set('esMision',false);
          controller.set('esConsultorio',false);
          controller.set('esCliente',true);
          controller.set('esPaciente',false);
        }else if(params.queryParams.tipo_salida == "Pacientes"){
          controller.set('esDonacion',false);
          controller.set('esCampanha',false);
          controller.set('esMision',false);
          controller.set('esConsultorio',false);
          controller.set('esCliente',false);
          controller.set('esPaciente',true);

        }else if(params.queryParams.tipo_salida == "Misiones"){
          controller.set('esDonacion',false);
          controller.set('esCampanha',false);
          controller.set('esMision',true);
          controller.set('esPaciente',false);
          controller.set('esCliente',false);
          controller.set('esConsultorio',false);
        }else if(params.queryParams.tipo_salida == "Donaciones"){
          controller.set('esMision',false);
          controller.set('esDonacion',true);
          controller.set('esCampanha',false);
          controller.set('donacion',true);
          controller.set('esConsultorio',false);
          controller.set('esCliente',false);
          controller.set('esPaciente',false);
        }

        controller.set('parametros', parametro);
        controller.set('mostrarImei', parametro.get('imeiEnVentaDetalle'));
        controller.set('mostrarVendedor', parametro.get('vendedorEnVenta'));
        controller.set('mostrarTarjetaCredito', parametro.get('tarjetaCreditoEnVenta'));
        controller.set('soportaMultimoneda', parametro.get('soportaMultimoneda'));
      } else {
        console.log("no parametro");
        controller.set('mostrarImei', false);
        controller.set('mostrarVendedor', false);
        controller.set('mostrarTarjetaCredito', false);
        controller.set('soportaMultimoneda', null);
      }
    });

    controller.set('detNuevo', this.store.createRecord('ventaDetalle'));
    controller.set('disablePrecio', !this.hasPermission('FE_editar_precio_venta'));

    this.store.find('moneda', { 'by_activo': true }).then(function(response) {
      controller.set('monedas', response);
    });
    var moneda = model.get('data.moneda');

    if (moneda) {
      controller.set('monedaSeleccionada', moneda);
    }

    var campanha = model.get('data.campanha');
    if (campanha) {
      controller.set('muestraCampanha', true);
      controller.set('campanhaSeleccionada', campanha);
    }

    this.store.find('medioPago').then(function(response) {
      controller.set('mediosPagos', response);
    });
    var medioPago = model.get('data.medioPago');

    if (medioPago) {
      controller.set('medioPagoSeleccionado', medioPago);

      if (medioPago.get('registraPago') || model.get('credito')) {
        controller.set('mostrarPagos', true);
      } else {
        controller.set('mostrarPagos', false);
      }
    }

    this.store.find('tarjeta', { unpaged: true, by_codigo_medio_pago: 'TC' }).then(function(response) {
      controller.set('tarjetas', response);
      var tarjeta = model.get('data.tarjeta');

      if (tarjeta) {
        controller.set('tarjetaSeleccionada', tarjeta);
        controller.set('esMedioPagoTarjetaCredito', true);
      }
    });

  }
});

var copiarModelo = function(idOrig, modeloNew, self) {
  var modeloOrig = self.store.find('venta', idOrig);
  modeloOrig.then(function(response) {
    self.controller.set('nombreCliente', response.get('nombreCliente'));
    self.controller.set('ruc', response.get('rucCliente'));

    if (self.controller.get('nombreCliente'))
      self.controller.set('clienteExistente', false);
    else
      self.controller.set('clienteExistente', true);

    var cliente = response.get('cliente');

    cliente.then(function(response) {
      self.controller.set('nombre', response.get('nombre'));
      self.controller.set('apellido', response.get('apellido'));
      if (!(self.controller.get('nombreCliente')))
        self.controller.set('ruc', response.get('ruc'));
      modeloNew.set('cliente', response);
    });

    var vendedor = response.get('vendedor');
    if (vendedor) {
      vendedor.then(function(response) {
        modeloNew.set('vendedor', response);
        self.controller.set('vendedorSeleccionado', response);
        console.log("vendedorSeleccionado: " + self.controller.get('vendedorSeleccionado'));
      });
    }
    console.log("Seteando moneda");
    var monedaVenta = response.get('moneda');
    console.log(monedaVenta);
    if (monedaVenta) {
      monedaVenta.then(function(response) {
        console.log(response);
        modeloNew.set('moneda', response);
        self.controller.set('monedaDefault', response);
        self.controller.set('monedaSeleccionada', response);
      });
    }



    var detalles = response.get('ventaDetalles');

    detalles.then(function(response) {
      //hay que ir metiendo cada detalle de a uno
      var detalles = response;
      var detallesNuevos = modeloNew.get('ventaDetalles');

      detallesNuevos.then(function(response) {
        self.controller.set('detalles', response);
        detalles.forEach(function(d) {
          var detalleNuevo = self.store.createRecord('ventaDetalle');
          detalleNuevo.set('producto', d.get('producto'));
          detalleNuevo.set('promocion', d.get('promocion'));
          detalleNuevo.set('descuento', d.get('descuento'));
          detalleNuevo.set('cantidad', d.get('cantidad'));
          detalleNuevo.set('caliente', d.get('caliente'));
          detalleNuevo.set('precio', d.get('precio'));
          detalleNuevo.set('imei', d.get('imei'));
          var monedaDetalle = d.get('moneda');
          if (monedaDetalle) {
            monedaDetalle.then(function(response) {
              console.log(response);
              detalleNuevo.set('moneda', response);
            });
          }
          var cotizacion = d.get('cotizacion');
          if (cotizacion) {
            cotizacion.then(function(response) {
              console.log(response);
              detalleNuevo.set('cotizacion', response);
            });
          }

          detalleNuevo.set('dirty', d.get('dirty'));
          console.log("se está seteando dirty con el valor: " + d.get('dirty') + " y queda el valor: " + detalleNuevo.get('dirty'));
          response.addRecord(detalleNuevo);
        });
      });
    });


    if (response.get('credito')) {
      var tipoCredito = response.get('tipoCredito');

      if (tipoCredito) {
        tipoCredito.then(function(response) {
          self.controller.set('tipoCreditoSeleccionado', response);
          self.controller.set('tipoCreditoDefault', response);
          modeloNew.set('tipoCredito', response);
        });
      }
      self.controller.set('edicionCredito', true);
    }


    self.store.find('empresa').then(function(response) {
      self.controller.set('empresas', response);
      var empresaDefault = response.objectAt(0);
      self.controller.set('empresaDefault', empresaDefault);
    });

    var sucursal = response.get('sucursal');

    sucursal.then(function(response) {
      var sucursalId = response.get('id');
      modeloNew.set('sucursal', response);
      self.controller.set('sucursalSeleccionada', response);
      /*var empresa = response.get('empresa');
      empresa.then(function(response) {
          self.controller.set('empresaSeleccionada', response);
      });*/

      var parametros = self.store.find('parametrosEmpresa', { 'by_sucursal': sucursalId, 'unpaged': true });
      parametros.then(function() {
        var parametro = parametros.objectAt(0);
        if (parametro) {
          self.controller.set('parametros', parametro);
          self.controller.set('mostrarImei', parametro.get('imeiEnVentaDetalle'));
          self.controller.set('mostrarVendedor', parametro.get('vendedorEnVenta'));
          self.controller.set('mostrarTarjetaCredito', parametro.get('tarjetaCreditoEnVenta'));
        } else {
          self.controller.set('mostrarImei', false);
          self.controller.set('mostrarVendedor', false);
          self.controller.set('mostrarTarjetaCredito', false);
        }
      });
    });

  });
};


Bodega.VentasNewRoute = Bodega.RequiereCajaAbiertaRoute.extend({
  queryParams: {
    ref: { replace: true },
    tipo_salida: { replace: true }
  },

  model: function(params) {
    console.log('NEW.ROUTE.MODEL / TIPO SALIDA: ', params.tipo_salida);

    if (params.ref) {
      console.log("VentasNewRoute ref= " + params.ref);
      this.set('ref', params.ref);
    }
    return this.store.createRecord('venta');
  },

  renderTemplate: function() {
    this.render('ventas.new', {
      controller: 'ventasNew'
    });
  },

  setupController: function(controller, model, params) {
    console.log('NEW.ROUTE.SETUP_CONTROLLER / TIPO_SALIDA: ', params.queryParams.tipo_salida);
    controller.set('tipo_salida', params.queryParams.tipo_salida);

    controller.set('model', model);
    controller.set('productoSeleccionado', null);
    controller.set('clienteExistente', false);
    controller.set('editando', false);
    controller.set('rucGarante', '');
    controller.set('medioPagoDetalles', false);
    controller.set('habilitaMedio', false);
    controller.set('permitirAgregarMedios', false);
    controller.set('campoDescuentoRedondeo', 0);
    controller.set('unicoMedioPago', true);
    controller.set('borraDetalle', true); //this.hasPermission('FE_delete_venta_detalle'));
    controller.set('lotesDeposito', null);
    controller.set('habilitaLote', false);
    controller.set('count', 0);
    controller.set('clienteActual', null);
    controller.set('muestraRUC', true);
    controller.set('muestraCampanha', false);




    var detallesMedio = model.get('ventaMedios');
    detallesMedio.then(function(response) {
      //console.log('then detalles:' + detalles);
      controller.set('detallesMedio', response);
    });


    var self = this;
    if (parseInt(this.get('ref')) > 0) { //si se trata de una duplicación
      //self.controller.set('clienteCargado',true); //Indica que no se tiene que volver a cargar el cliente
      this.store.find('tipoCredito').then(function(response) {
        //console.log('tipos de créditos:' + response)
        controller.set('tiposCreditos', response);
        controller.set('tipoCreditoDefault', response.objectAt(0));
        controller.set('tipoCreditoSeleccionado', response.objectAt(0));
      });

      this.store.find('vendedor', { 'by_activo': true, 'unpaged': true }).then(function(response) {
        controller.set('vendedores', response);
        controller.set('vendedorSeleccionado', response.objectAt(0));
      });

      copiarModelo(this.get('ref'), model, this);

      var parametros = self.store.find('parametrosEmpresa', { unpaged: true });
      parametros.then(function() {
        var parametro = parametros.objectAt(0);

        if (parametro) {
          controller.set('parametros', parametro);

          var labelGuardar = "Guardar e Imprimir";
          if (!parametro.get('soportaImpresionFacturaVenta')) {
            labelGuardar = "Guardar";
          }

          controller.set('soportaImpresionFacturaVenta', parametro.get('soportaImpresionFacturaVenta'));
          controller.set('maxDetalles', parametro.get('maxDetallesVentas'));
          controller.set('labelGuardar', labelGuardar);
          controller.set('mostrarImei', parametro.get('imeiEnVentaDetalle'));
          controller.set('mostrarVendedor', parametro.get('vendedorEnVenta'));
          controller.set('mostrarTarjetaCredito', parametro.get('tarjetaCreditoEnVenta'));
          controller.set('soportaSucursales', parametro.get('soportaSucursales'));
          controller.set('soportaMultimoneda', parametro.get('soportaMultimoneda'));
          var moneda = parametro.get('moneda');

          moneda.then(function() {
            console.log("VENTAS.NEW.ROUTE: SETEANDO MONEDA EN CONTROLLER");
            console.log(moneda.get('content'));

            controller.set('monedaDefault', moneda.get('content'));
            controller.set('monedaSeleccionada', moneda.get('content'));
          });
        } else {
          controller.set('mostrarImei', false);
          controller.set('mostrarVendedor', false);
          controller.set('mostrarTarjetaCredito', false);
          controller.set('soportaMultimoneda', false);
          controller.set('monedaDefault', null);
        }
      });

    } else {
      var detalles = model.get('ventaDetalles');
      //En caso de que sea una venta nueva.
      controller.set('clienteCargado', false);
      controller.set('garanteCargado', false);
      //console.log('detalles:' + detalles);
      this.store.find('tipoCredito', { 'by_contado': true }).then(function(response) {
        //console.log('tipos de créditos:' + response)

        //controller.set('tipoCreditoDefault', response.objectAt(0));
        //controller.set('tipoCreditoSeleccionado', response.objectAt(0));
        controller.set('tipoCreditoContado', response.objectAt(0));
      });

      this.store.find('tipoCredito', { 'by_credito': true, 'unpaged': true }).then(function(response) {
        controller.set('tiposCreditos', response);
        controller.set('tipoCreditoDefault', response.objectAt(0));
        controller.set('tipoCreditoSeleccionado', response.objectAt(0)); //el primero es mensual
      });

      this.store.find('vendedor', { 'by_activo': true, 'unpaged': true }).then(function(response) {
        controller.set('vendedores', response);
        controller.set('vendedorSeleccionado', response.objectAt(0));
      });

      detalles.then(function(response) {
        //console.log('then detalles:' + detalles);
        controller.set('detalles', response);
      });

      this.store.find('empresa').then(function(response) {
        //console.log('tipos de créditos:' + response)
        controller.set('empresas', response);
        var empresaDefault = response.objectAt(0);
        controller.set('empresaDefault', empresaDefault);

        if (empresaDefault) {
          var sucursales = self.store.find('sucursal', { 'unpaged': true, 'by_activo': true, 'by_empresa': empresaDefault.get('id') });

          sucursales.then(function() {
            var sucursal = sucursales.objectAt(0);

            if (sucursal) {
              controller.set('sucursalSeleccionada', sucursal);
              model.set('sucursal', sucursal);
            } else {
              controller.set('sucursalSeleccionada', null);
              model.set('sucursal', null);
            }
            controller.set('sucursales', sucursales);
          });



        }
      });
    }


    var parametros = self.store.find('parametrosEmpresa', { unpaged: true });
    parametros.then(function() {
      var parametro = parametros.objectAt(0);

      if (parametro) {
        controller.set('parametros', parametro);

        var labelGuardar = "Guardar e Imprimir";
        if (!parametro.get('soportaImpresionFacturaVenta')) {
          labelGuardar = "Guardar";
        }


        if(params.queryParams.tipo_salida == "donaciones"){
          controller.set('esMision',false);
          controller.set('esDonacion',true);
          controller.set('esCampanha',false);
          controller.set('donacion',true);
          controller.set('esConsultorio',false);
          controller.set('esCliente',false);
          controller.set('esPaciente',false);


          self.store.find('tipo_salida',{by_codigo: 'Donaciones'}).then(function(responsetipo){
            controller.set('tipoSalida',responsetipo.objectAt(0));

            if(responsetipo.objectAt(0).get('muestraMediosPago') == true){
              controller.set('muestraMedios',true);
            }else{
              controller.set('muestraMedios',false);
            }
          });

        }else if(params.queryParams.tipo_salida == "campañas"){
          controller.set('esMision',false);
          controller.set('esDonacion',false);
          controller.set('esCampanha',true);
          controller.set('esConsultorio',false);
          controller.set('esCliente',false);
          parametro.get('empresa').then(function(response){
            controller.set('nombreEmpresa',response.get('nombre'));
            var campanhas = self.store.find('campanha',{by_tipo_campanha: "Campaña"});
            campanhas.then(function(response) {
              controller.set('campanhas', response);
              controller.set('campanhaSeleccionada', response.objectAt(0));
            });

            self.store.find('tipo_salida',{by_codigo: 'Campañas'}).then(function(responsetipo){
              controller.set('tipoSalida',responsetipo.objectAt(0));
              if(responsetipo.objectAt(0).get('muestraMediosPago') == true){
                controller.set('muestraMedios',true);
              }else{
                controller.set('muestraMedios',false);
              }
            });

            self.store.find('persona',{ by_razon_social: 'Operación Sonrisa Paraguay' }).then(function(responsePersona){
              controller.set('personaEmpresa',responsePersona.objectAt(0));
            });
          });



        }else if(params.queryParams.tipo_salida == "misiones"){
          controller.set('esDonacion',false);
          controller.set('esCampanha',false);
          controller.set('esMision',true);
          controller.set('esPaciente',false);
          controller.set('esCliente',false);
          controller.set('esConsultorio',false);
          parametro.get('empresa').then(function(response){
            controller.set('nombreEmpresa',response.get('nombre'));

            self.store.find('tipo_salida',{by_codigo: 'Misiones'}).then(function(responsetipo){
              controller.set('tipoSalida',responsetipo.objectAt(0));
              if(responsetipo.objectAt(0).get('muestraMediosPago') == true){
                controller.set('muestraMedios',true);
              }else{
                controller.set('muestraMedios',false);
              }
            });

            self.store.find('persona',{ by_razon_social: 'Operación Sonrisa Paraguay' }).then(function(responsePersona){
              controller.set('personaEmpresa',responsePersona.objectAt(0));
            });
          });
        }else if(params.queryParams.tipo_salida == "consultorio"){
          controller.set('esDonacion',false);
          controller.set('esCampanha',false);
          controller.set('esMision',false);
          controller.set('esCliente',false);
          controller.set('esPaciente',false);
          controller.set('esConsultorio',true);
          parametro.get('empresa').then(function(response){
            controller.set('nombreEmpresa',response.get('nombre'));

            self.store.find('tipo_salida',{by_codigo: 'consultorio'}).then(function(responsetipo){
              controller.set('tipoSalida',responsetipo.objectAt(0));
              if(responsetipo.objectAt(0).get('muestraMediosPago') == true){
                controller.set('muestraMedios',true);
              }else{
                controller.set('muestraMedios',false);
              }
            });

            self.store.find('persona',{ by_razon_social: 'Operación Sonrisa Paraguay' }).then(function(responsePersona){
              controller.set('personaEmpresa',responsePersona.objectAt(0));
            });
          });

          self.store.find('consultorio',{'unpaged': true}).then(function(response) {
            self.controller.set('consultorios',response);
            self.controller.set('consultorioSeleccionado', response.objectAt(0));
          });




        }else if(params.queryParams.tipo_salida == "clientes"){
          controller.set('esDonacion',false);
          controller.set('esCampanha',false);
          controller.set('esMision',false);
          controller.set('esConsultorio',false);
          controller.set('esCliente',true);
          controller.set('esPaciente',false);
          self.store.find('tipo_salida',{by_codigo: 'Clientes'}).then(function(responsetipo){
            controller.set('tipoSalida',responsetipo.objectAt(0));
            console.log('muestraMedios');
            console.log(responsetipo.objectAt(0).get('muestraMediosPago'));
            if(responsetipo.objectAt(0).get('muestraMediosPago') == true){
              controller.set('muestraMedios',true);
            }else{
              controller.set('muestraMedios',false);
            }
          });

        }else if(params.queryParams.tipo_salida == "pacientes"){
          controller.set('esDonacion',false);
          controller.set('esCampanha',false);
          controller.set('esMision',false);
          controller.set('esConsultorio',false);
          controller.set('esCliente',false);
          controller.set('esPaciente',true);

          self.store.find('tipo_salida',{by_codigo: 'Pacientes'}).then(function(responsetipo){
            controller.set('tipoSalida',responsetipo.objectAt(0));
            if(responsetipo.objectAt(0).get('muestraMediosPago') == true){
              controller.set('muestraMedios',true);
            }else{
              controller.set('muestraMedios',false);
            }
          });
        }

        controller.set('soportaImpresionFacturaVenta', parametro.get('soportaImpresionFacturaVenta'));
        controller.set('maxDetalles', parametro.get('maxDetallesVentas'));
        controller.set('labelGuardar', labelGuardar);
        controller.set('mostrarImei', parametro.get('imeiEnVentaDetalle'));
        controller.set('mostrarVendedor', parametro.get('vendedorEnVenta'));
        controller.set('mostrarTarjetaCredito', parametro.get('tarjetaCreditoEnVenta'));
        controller.set('soportaSucursales', parametro.get('soportaSucursales'));
        controller.set('soportaMultimoneda', parametro.get('soportaMultimoneda'));
        var moneda = parametro.get('moneda');

        moneda.then(function() {
          console.log("VENTAS.NEW.ROUTE: SETEANDO MONEDA EN CONTROLLER");
          console.log(moneda.get('content'));

          controller.set('monedaDefault', moneda.get('content'));
          controller.set('monedaSeleccionada', moneda.get('content'));
        });
      } else {
        controller.set('mostrarImei', false);
        controller.set('mostrarVendedor', false);
        controller.set('mostrarTarjetaCredito', false);
        controller.set('soportaMultimoneda', false);
        controller.set('monedaDefault', null);
      }
    });




    controller.set('detNuevo', this.store.createRecord('ventaDetalle'));
    controller.set('detMedioNuevo', this.store.createRecord('ventaMedio'));

    controller.set('disablePrecio', !this.hasPermission('FE_editar_precio_venta'));
    controller.set('descripcionSW', null);
    controller.set('productoSeleccionadoSW', null);
    this.set('ref', 0);

    this.store.find('moneda', { 'by_activo': true }).then(function(response) {
      controller.set('monedas', response);
    });

    this.store.find('medioPago').then(function(response) {
      controller.set('mediosPagos', response);
      controller.set('mediosPagosModal', response);

      console.log(response);
      controller.set('medioPagoSeleccionado', response.objectAt(0));
      controller.set('medioPagoSeleccionadoDefault', response.objectAt(0));
      controller.set('medioPagoSeleccionadoModal', response.objectAt(0));

    });

    this.store.find('tarjeta', { unpaged: true, by_codigo_medio_pago: 'TC', by_activo: true }).then(function(response) {
      if (response.content) {
        controller.set('tarjetasDeCredito', response.content);
        controller.set('tarjetasDeCreditoModal', response.content);

      }
    });

    this.store.find('tarjeta', { unpaged: true, by_codigo_medio_pago: 'TD', by_activo: true }).then(function(response) {
      if (response.content) {
        controller.set('tarjetasDeDebito', response.content);
        controller.set('tarjetasDeDebitoModal', response.content);

      }


    });

    controller.set('montoCotizacionAjustado', null);
  }



  // afterModel: function(){
  //   console.log('LLAMADA A afterModel');
  // }
});

Bodega.VentaDeleteRoute = Bodega.RequiereCajaAbiertaRoute.extend({
  model: function(params) {
    return this.modelFor('venta');
  },

  renderTemplate: function() {
    this.render('ventas.delete', {
      controller: 'ventaDelete'
    });
  }
});

Bodega.VentaCuotasIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    var venta = this.modelFor('venta');
    console.log("INDEX");
    //var cuotas = venta.get('ventaCuota');

    //cuotas.then();
    var cuotas = this.store.find('ventaCuota', {
      by_venta: venta.id
    });
    return cuotas;
  },

  renderTemplate: function() {
    console.log("RENDER TEMPLATE");
    this.render('ventas.cuotas.index', {
      controller: 'ventaCuotasIndex'
    });
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    var venta = this.modelFor('venta');
    controller.set('nroFactura', venta.get('nroFacturaFormateado'));
    controller.set('staticFilters', {
      by_venta: venta.get('id')
    });
  }
});



Bodega.VentaCuotaEditRoute = Bodega.RequiereCajaAbiertaRoute.extend({
  model: function(params) {
    return this.modelFor('ventaCuota');
  },

  renderTemplate: function() {
    this.render('ventas.cuotas.edit', {
      controller: 'ventaCuotaEdit'
    });

  },

  setupController: function(controller, model) {
    controller.set('model', model);
    var fechaCobro = model.get('fechaCobro');
    if (!fechaCobro) {
      fechaCobro = moment().toDate();
      model.set('fechaCobro', fechaCobro);
    }
    var venta = this.modelFor('venta');
    console.log(venta);
    controller.set('venta_id', venta.get('id'));
  }
});
