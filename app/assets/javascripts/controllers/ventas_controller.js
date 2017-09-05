Bodega.VentasIndexController = Ember.ArrayController.extend(Bodega.mixins.Pageable, Bodega.mixins.Filterable, {
  resource: 'venta',
  queryParams: ['ref', 'tipo_salida'],
  ref: null,
  tipo_salida: null,
  perPage: 9,
  hasSearchForm: true,
  searchFormTpl: 'ventas/searchform',
  searchFormModal: '#ventaSearchForm',

  tituloTipoSalida: null,

  tipoSalidaObserver: function() {
    switch(tipo_salida) {
      case "clientes":
        this.set('tituloTipoSalida', "Venta"); break;
      case "pacientes":
        this.set('tituloTipoSalida', "Salida Medicamentos"); break;
      case "consultorio":
        this.set('tituloTipoSalida', "Reposición Consultorios"); break;
      case "campañas":
        this.set('tituloTipoSalida', "Salida Campañas"); break;
      case "misiones":
        this.set('tituloTipoSalida', "Salida Misiones"); break;
      case "donaciones":
        this.set('tituloTipoSalida', "Salida Donaciones"); break;
      default:
        this.set('tituloTipoSalida', "Salida"); break;
    }
  }.observes('tipo_salida'),


  apiNamespace: '/api/v1/',

  factory: 'ventas',

  restVerb: 'imprimir',

  clearSearchForm: function() {

    this.set('nombreCliente', '');
    this.set('apellidoCliente', '');
    this.set('rucCliente', '');
    this.set('fechaAntes', '');
    this.set('fechaDia', '');
    this.set('fechaDespues', '');
    this.set('nroFactura', '');
    // this.set('selectedSucursal', null);
  },

  actions: {
    criteriaSearch: function() {

      var self = this;
      var filters = this.get('filters');
      var fechaAntes = this.get('fechaAntes');
      var fechaDia = this.get('fechaDia');
      var fechaDespues = this.get('fechaDespues');
      // var selectedSucursal = this.get('selectedSucursal');
      var nombreCliente = this.get('nombreCliente');
      var rucCliente = this.get('rucCliente');
      var apellidoCliente = this.get('apellidoCliente');
      var nroFactura = this.get('nroFactura');
      var imei = this.get('imei');

      if (fechaAntes) {
        filters.by_fecha_registro_before = fechaAntes;
      }

      if (fechaDespues) {
        filters.by_fecha_registro_after = fechaDespues;
      }

      if (fechaDia) {
        filters.by_fecha_registro_on = fechaDia;
      }

      //if(selectedSucursal){
      //filters.by_sucursal_id = selectedSucursal.get('id');
      //}

      if (nombreCliente) {
        filters.by_cliente_nombre = this.get('nombreCliente');
      }

      if (apellidoCliente) {
        filters.by_cliente_apellido = this.get('apellidoCliente');
      }

      if (rucCliente) {
        filters.by_cliente_ruc = this.get('rucCliente');
      }

      if (nroFactura) {
        filters.by_nro_factura = nroFactura;
      }

      if (imei) {
        filters.by_imei = this.get('imei');
        console.log('IMEI');
        console.log(this.get('imei'));
      }

      this.set('filters', filters);
      this.store.find('venta', filters).then(function(model) {
        self.set('model', model);
      });
    },

    imprimir: function(id) {
      //var fd = new FormData();
      var api = this.get('apiNamespace');
      var attribute = this.get('restVerb');
      var urlService = api + this.get('factory') + '/' + id + '/' + attribute;
      var self = this;

      $.ajax({
        url: urlService,
        type: "GET",
        data: {},
        processData: false,
        contentType: false,
        xhr: function() {
          var xhr = $.ajaxSettings.xhr();
          // set the onprogress event handler
          xhr.upload.onprogress = function(evt) {
            //self.set('progress', (evt.loaded/evt.total*100));
          };
          return xhr;
        }
      }).done(function(data, textStatus, jqXHR) {
        Bodega.Notification.show('Éxito', 'Venta ' + data.venta.nro_factura + ' impresa');
      }).fail(function(jqXHR, textStatus, errorThrown) {
        console.log("error al imprimir");
        Bodega.Notification.show('Error', 'Ocurrió un error al imprimir la venta', Bodega.Notification.ERROR_MSG);
      });
    }

  }
});


Bodega.VentasBaseController = Ember.ObjectController.extend({
  queryParams: ['ref', 'tipo_salida'],
  ref: null,
  tipo_salida: null,

  needs: ['application'],

  formTitle: '',

  detalleTitle: 'Nuevo Detalle',

  numeral: '#',

  maxDetalles: 33,

  imgMissing: '/images/missing_small.png',

  promocion: null,

  hola: null,

  productoSeleccionado: null,

  tipoCredito: null,

  feedback: Ember.Object.create(),

  enters: 2,

  canEditPrecio: false,

  agregandoDetalle: false,

  campoDescuentoRedondeo: 0,

  CODIGO_TARJETA_CREDITO: 'TC',

  CODIGO_TARJETA_DEBITO: 'TD',

  imprimirFactura: function(venta) {
    //console.log("VentasBaseController->imprimirFactura venta:" + venta);
    var params = {};
    var downloadParams = {};
    params.content_type = 'pdf';
    downloadParams.httpMethod = 'GET';
    if (venta.get('usoInterno')) {
      params.tipo = "uso_interno";
    } else {
      params.tipo = "factura";
    }
    params.venta_id = venta.get('id');

    downloadParams.data = params;
    Bodega.Utils.printPdf('/api/v1/ventas/', params);
    //Bodega.$.fileDownload("/api/v1/ventas/", downloadParams);
  },

  totalFinal: function() {
    var detalles = this.get('detalles');
    var total = 0;
    var self = this;
    var model = this.get('model');
    var moneda = this.get('monedaSeleccionada');

    if (this.get('editando') && !this.get('soportaMultimoneda')) {
      return model.get('total');
    }
    total = this.get('totalSinDescuento') - this.get('descuentoTotal');

    if (!this.get('soportaMultimoneda')) {
      return moneda && moneda.get('redondeo') ? Math.round(total) : total;
    } else {
      return moneda && moneda.get('redondeo') ? Math.round(total).toFixed(2) : total.toFixed(2);
    }
    //return moneda && moneda.get('redondeo') ? Math.round(total).toFixed(2) : total.toFixed(2);
  }.property('detalles.@each.precio', 'detalles.@each.descuento', 'detalles.@each.cantidad',
    'tipoCreditoSeleccionado', 'descuentoTotal', 'credito', 'detalles.@each.subtotalCotizado'),

  calcularGanancia: function() {
    var detalles = this.get('detalles');
    var totalCosto = 0;
    var self = this;

    var model = this.get('model');
    if (this.get('editando') && !this.get('soportaMultimoneda')) {
      return model.get('ganancia');
    }

    if (detalles) {
      detalles.forEach(function(detalle) {
        var producto = detalle.get('producto');
        var precio_promedio = 0;
        if (producto !== null) {
          precio_promedio = producto.get('precioPromedio');
        }

        totalCosto += parseFloat(precio_promedio) * parseFloat(detalle.get('cantidad'));

        if (detalle.get('multiplicar')) {
          totalCosto *= parseFloat(detalle.get('montoCotizacion'));
        } else {
          totalCosto /= parseFloat(detalle.get('montoCotizacion'));
        }
      });
    }

    var ganancia = this.get('totalFinal') - totalCosto;
    console.log('GANANCIA', this.get('totalFinal'), totalCosto, ganancia);
    if (isNaN(ganancia)) {
      if (model.get('ganancia') !== undefined) {
        ganancia = model.get('ganancia');
      } else {
        ganancia = 0;
      }
    }
    return ganancia;
  }.property('total'),

  totalSinDescuento: function() {
    var detalles = this.get('detalles');
    var total = 0;
    var self = this;
    var model = this.get('model');

    if (this.get('editando') && !this.get('soportaMultimoneda')) {
      return model.get('total') + model.get('descuento');
    }

    if (detalles) {

      if (self.get('soportaMultimoneda')) {
        detalles.forEach(function(detalle) {
          total += parseFloat(detalle.get('subtotalCotizado'));
          // el subtotal cotizado ya consideró el descuento, hay que volver a sumar.
          if (detalle.get('descuento')) {
            total += parseFloat(detalle.get('descuento'));
          }
        });
      } else {
        detalles.forEach(function(detalle) {
          total += parseFloat(detalle.get('precio')) * parseFloat(detalle.get('cantidad'));
        });
      }
    }

    if (!this.get('soportaMultimoneda')) {
      return total;
    } else {
      return total.toFixed(2);
    }
  }.property('detalles.@each.precio', 'detalles.@each.cantidad', 'detalles.@each.subtotalCotizado'),

  iva10Total: function() {
    var detalles = this.get('detalles');
    var total = 0;
    var self = this;
    var iva;

    var model = this.get('model');
    if (this.get('editando') && !this.get('soportaMultimoneda')) {
      return model.get('iva10');
    }
    var moneda = this.get('monedaSeleccionada');

    if (detalles) {
      detalles.forEach(function(detalle) {
        var producto = detalle.get('producto');

        if (producto !== null && producto.get('iva')) {

          if (detalle.get('producto').get('iva') === 10) {

            if (self.get('soportaMultimoneda')) {
              total += parseFloat(detalle.get('subtotalCotizado'));
            } else {
              total += parseFloat(detalle.get('subtotal'));
            }
          }
        } else {
          //la primera vez no carga el cálculo, se devuelve del modelo
          iva = self.get('model').get('iva10');
          return true;
        }
        return false;
      });
    }

    if (iva) {
      return iva;
    } else {
      if (!this.get('soportaMultimoneda')) {
        return moneda && moneda.get('redondeo') ? Math.round(total / 11) : (total / 11);
      } else {
        return moneda && moneda.get('redondeo') ? Math.round(total / 11).toFixed(2) : (total / 11).toFixed(2);
      }

    }

  }.property('detalles.@each.precio', 'detalles.@each.descuento', 'detalles.@each.cantidad',
    'detalles.@each.subtotalCotizado'),

  iva5Total: function() {
    var detalles = this.get('detalles');
    var total = 0;
    var self = this;
    var model = this.get('model');
    var moneda = this.get('monedaSeleccionada');

    if (this.get('editando') && !this.get('soportaMultimoneda')) {
      return model.get('iva5');
    }

    if (detalles) {
      detalles.forEach(function(detalle) {
        var producto = detalle.get('producto');

        if (producto !== null && producto.get('iva') == 5) {

          if (self.get('soportaMultimoneda')) {
            total += parseFloat(detalle.get('subtotalCotizado'));
          } else {
            total += parseFloat(detalle.get('subtotal'));
          }
        }
      });
    }

    if (!this.get('soportaMultimoneda')) {
      return moneda && moneda.get('redondeo') ? Math.round(total / 21) : (total / 21);
    } else {
      return moneda && moneda.get('redondeo') ? Math.round(total / 21).toFixed(2) : (total / 21).toFixed(2);
    }

  }.property('detalles.@each.precio', 'detalles.@each.descuento', 'detalles.@each.cantidad', 'detalles.@each.subtotalCotizado'),

  descuentoTotal: function() {
    var detalles = this.get('detalles');
    var total = 0;
    var self = this;
    var descuentoRedondeo = this.get('campoDescuentoRedondeo');
    var model = this.get('model');

    if (this.get('editando') && !this.get('soportaMultimoneda')) {
      return model.get('descuento');
    }

    if (detalles) {
      detalles.forEach(function(detalle) {
        total += parseFloat(detalle.get('descuento'));
      });
    }

    if (descuentoRedondeo) {
      total = total + parseFloat(descuentoRedondeo);
    }

    if (!this.get('soportaMultimoneda')) {
      return total;
    } else {
      return total.toFixed(2);
    }

  }.property('detalles.@each.descuento', 'campoDescuentoRedondeo'),

  loadSucursal: function() {
    var empresaSeleccionada = this.get('empresaSeleccionada');
    var self = this;
    self.set('detNuevo');
    if (empresaSeleccionada) {
      var sucursales = this.store.find('sucursal', { 'unpaged': true, 'by_activo': true, 'by_empresa': empresaSeleccionada.get('id') });

      sucursales.then(function() {
        self.set('sucursales', sucursales);
        var sucursal = sucursales.objectAt(0);
        var model = self.get('model');

        if (!self.get('sucursalSeleccionada')) {
          if (sucursal) {
            self.set('sucursalSeleccionada', sucursal);
            model.set('sucursal', sucursal);

          } else {
            self.set('sucursalSeleccionada', null);
            model.set('sucursal', null);
          }
        }
      });

      var parametros = self.store.find('parametrosEmpresa', { 'by_empresa': empresaSeleccionada.get('id'), 'unpaged': true });

      parametros.then(function() {
        var parametro = parametros.objectAt(0);
        self.set('parametros', parametro);
        if (parametro) {
          self.set('mostrarImei', parametro.get('imeiEnVentaDetalle'));
          self.set('mostrarVendedor', parametro.get('vendedorEnVenta'));
          self.set('mostrarTarjetaCredito', parametro.get('tarjetaCreditoEnVenta'));
          self.set('soportaSucursales', parametro.get('soportaSucursales'));

        } else {
          self.set('mostrarImei', false);
          self.set('mostrarVendedor', false);
          self.set('mostrarTarjetaCredito', false);
          self.set('soportaSucursales', false);
        }
      });
    } else {
      //console.log('loadSucursal: empresaSeleccionada null');
    }
  }.observes('empresaSeleccionada'),


  loadProducto: function() {

    if (!this.get('agregandoDetalle')) {
      var codigoBarra = this.get('codigoBarra');
      var detalle = this.get('detNuevo');
      var self = this;
      var model = this.get('model');
      var descripcionSW = this.get('descripcionSW');
      var moneda = self.get('monedaSeleccionada');
      var tarjeta = self.get('tarjetaSeleccionada');
      var tarjetaID = tarjeta ? tarjeta.get('id') : null;

      var tipoCredito = self.get('tipoCreditoSeleccionado');
      var medioPago = self.get('medioPagoSeleccionado');
      var cantidadCuotas = self.get('cantidadCuotasTmp');

      if (codigoBarra && detalle) {
        var montoCotizacion = detalle.get('montoCotizacion');
        var queryParams = {
          'aplicar_promocion[cantidad]': detalle.get('cantidad'),
          'aplicar_promocion[caliente]': detalle.get('caliente'),
          'aplicar_promocion[codigo]': codigoBarra,
          'aplicar_promocion[ruc]': this.get('ruc'),
          'aplicar_promocion[sucursal_id]': self.get('sucursalSeleccionada').get('id'),
          'sucursal_id': self.get('sucursalSeleccionada').get('id')
        };

        if (moneda) {
          queryParams['aplicar_promocion[moneda_id]'] = moneda.get('id');
        }

        if (medioPago) {
          queryParams['aplicar_promocion[medio_pago_id]'] = medioPago.get('id');
        }

        if (model.get('credito')) {
          if (tipoCredito) {
            queryParams['aplicar_promocion[tipo_credito_id]'] = tipoCredito.get('id');
          }

          if (cantidadCuotas) {
            queryParams['aplicar_promocion[cantidad_cuotas]'] = cantidadCuotas;
          }
        }

        if (tarjeta && self.get('unicoMedioPago')) {
          queryParams['aplicar_promocion[tarjeta_id]'] = tarjeta.get('id');
        }

        if (montoCotizacion) {
          montoCotizacion = parseFloat(montoCotizacion);

          if (!detalle.get('multiplicar')) {
            montoCotizacion = 1 / montoCotizacion;
          }
          queryParams['aplicar_promocion[monto_cotizacion]'] = montoCotizacion;
        }
        var productos = this.store.find('producto', queryParams);


        detalle.set('dirty', true);
        productos.then(function() {
          var detalle = self.get('detNuevo');
          if (!self.get('agregandoDetalle') && detalle.get('dirty')) {
            var producto = productos.objectAt(0);


            var model = self.get('model');
            if (producto) {
              tipoProducto = producto.get('tipoProducto');
              tipoProducto.then(function() {
                if (tipoProducto.get('usaLote')) {
                  self.set('habilitaLote', true);
                  loteDepositoParams = {};
                  loteDepositoParams.by_producto_id = producto.get('id');
                  loteDepositoParams.unpaged = true;
                  loteDepositoParams.usa_lote = true;
                  loteDepositoParams.by_excluye_fuera_de_stock = true;

                  self.store.find('loteDeposito', loteDepositoParams).then(function(response) {
                    self.set('lotesDeposito', response);
                    self.set('loteSeleccionadoModal', response.objectAt(0));
                  });

                } else {
                  self.set('habilitaLote', false);
                }
              });
              producto.transitionTo('saved');
              var productoSeleccionado = self.get('productoSeleccionado');

              var precio = producto.get('precio');
              //console.log("precio %o", precio);

              if (moneda.get('redondeo')) {
                precio = Math.round(precio)
              } else {
                precio = precio.toFixed(2);
              }

              if (productoSeleccionado === null) {
                detalle.set('precio', precio);
              } else if (productoSeleccionado.get('id') != producto.get('id')) {
                detalle.set('precio', precio);
              }

              //console.log("subtotal %o", detalle.subtotal);
              self.set('productoSeleccionado', producto);
              self.set('descripcion', producto.get('descripcion'));
              detalle.set('producto', producto);
              detalle.set('descuento', producto._data.descuento);
              producto.get('moneda').then(function(moneda) {
                detalle.set('moneda', moneda);
              });
              self.set('descripcionSW', producto._data.descripcion);

              if (producto._data.promocion_aplicada) {
                var promoStore = self.store.getById('promocion', producto._data.promocion_aplicada.id);
                var promocion = null;

                if (promoStore) {
                  promocion = promoStore;
                } else {
                  promocion = self.store.createRecord('promocion', producto._data.promocion_aplicada);
                  promocion.transitionTo('saved');
                }
                detalle.set('promocion', promocion);
                promocion.set('tipo', producto._data.promocion_aplicada.tipo);
              } else {
                detalle.set('promocion', null);
              }
              $('#cantidadDetalle').focus();

            } else {
              self.set('productoSeleccionado', null);
              detalle.set('cantidad', 1);
              detalle.set('producto', null);
              detalle.set('precio', 0);
              detalle.set('descuento', 0);
              detalle.set('promocion', null);
              self.set('descripcionSW', '');
            }
          }
        });
      } else if (!codigoBarra) {
        self.set('productoSeleccionado', null);
        /*
        detalle.set('cantidad', 1);
        detalle.set('producto', null);
        detalle.set('precio', 0);
        detalle.set('descuento', 0);
        detalle.set('promocion', null);
        */
        self.set('descripcionSW', '');
      }
    }
  },

  pruebax: function() {
    console.log(this.get('detNuevo.montoCotizacion'));
    this.loadProducto();
  }.observes('ruc', 'detNuevo.cantidad', 'detNuevo.caliente', 'sucursalSeleccionada', 'monedaSeleccionada', 'tarjetaSeleccionada', 'detNuevo.montoCotizacion'),

  cotizarSubTotal: function() {
    //if (this.get('soportaMultimoneda')) {
    console.log('EN COTIZAR SUBTOTAL');
    var moneda = this.get('monedaSeleccionada');
    var producto = this.get('productoSeleccionado');
    var self = this;

    if (!moneda || !producto) {
      return;
    }
    var detalle = this.get('detNuevo');

    function doCotizacion(cotizacion, multiplicar) {

      if (!cotizacion) {
        Bodega.Notification.show('Atención', 'Debe definir una cotización de ' +
          producto.get('moneda').get('simbolo') + ' a ' +
          moneda.get('simbolo') + ' para realizar la venta.',
          Bodega.Notification.WARNING_MSG);
        return;
      }
      var subtotalCotizado = detalle.get('precio') * detalle.get('cantidad');
      detalle.set('multiplicar', multiplicar);
      detalle.set('montoCotizacion', cotizacion.get('monto'));

      if (!self.get('montoCotizacionAjustado')) {
        self.set('montoCotizacionAjustado', cotizacion.get('monto'));
      }

      if (multiplicar) {
        subtotalCotizado *= detalle.get('montoCotizacion');
      } else {
        subtotalCotizado /= detalle.get('montoCotizacion');
      }

      if (self.get('soportaMultimoneda')) {
        detalle.set('descuento', parseFloat(detalle.get('descuento')).toFixed(2));
        subtotalCotizado = subtotalCotizado.toFixed(2);
        subtotalCotizado = subtotalCotizado - detalle.get('descuento');
        subtotalCotizado = subtotalCotizado.toFixed(2);
      } else {
        detalle.set('descuento', parseFloat(detalle.get('descuento')));
        subtotalCotizado = subtotalCotizado;
        subtotalCotizado = subtotalCotizado - detalle.get('descuento');
        subtotalCotizado = subtotalCotizado;
      }


      detalle.set('cotizacion', cotizacion);
      detalle.set('subtotalCotizado', subtotalCotizado);
    }

    producto.get('moneda').then(function() {
      console.log("Llamando a buscarCotizacion");
      self.buscarCotizacion(moneda, producto.get('moneda').get('content'), doCotizacion);
    });
    //}
  }.observes('monedaSeleccionada', 'productoSeleccionado'),

  onMontoCotizacionAjustadoChange: function() {
    //if (this.get('soportaMultimoneda')) {
    var detalle = this.get('detNuevo');
    if (!detalle || !this.get('montoCotizacionAjustado')) {
      return;
    }
    var montoCotizacionAjustado = parseFloat(this.get('montoCotizacionAjustado'));
    var subtotalCotizado = detalle.get('precio') * detalle.get('cantidad');

    if (detalle.get('multiplicar')) {
      subtotalCotizado *= montoCotizacionAjustado;
    } else {
      subtotalCotizado /= montoCotizacionAjustado;
    }


    //detalle.set('descuento', parseFloat(detalle.get('descuento')).toFixed(2));
    subtotalCotizado = subtotalCotizado.toFixed(2);
    subtotalCotizado = subtotalCotizado - detalle.get('descuento');
    subtotalCotizado = subtotalCotizado.toFixed(2);


    detalle.set('subtotalCotizado', subtotalCotizado);
    detalle.set('montoCotizacion', montoCotizacionAjustado);
    //}
  }.observes('montoCotizacionAjustado', 'detNuevo.cantidad', 'detNuevo.descuento', 'detNuevo.precio'),

  onMonedaChanged: function() {
    this.set('montoCotizacionAjustado', null);
  }.observes('monedaSeleccionada'),

  /**
   * Método que recalcula los subtotales de los detalles que ya fueron agregados.
   *
   * Si hubo un cambio de moneda, se recotiza
   * Si hubo un cambio de tarjeta, se recalcula la promoción aplicada
   **/
  recotizarDetallesSubtotal: function() {
    //if (this.get('soportaMultimoneda')) {
    console.log("[ventas_controller.recotizarDetallesSubtotal]");
    var self = this;
    var detalles = self.get('detalles') || [];
    var moneda = self.get('monedaSeleccionada');
    var model = self.get('model');
    var tarjeta = self.get('tarjetaSeleccionada');
    var montoCotizacionAjustado = this.get('montoCotizacionAjustado');

    if (moneda) {
      console.log("Seteando moneda:");
      model.set('moneda', moneda);
    }
    detalles.forEach(function(detalle) {
      var producto = detalle.get('producto');

      function doCotizacion(cotizacion, multiplicar) {
        console.log("[ventas_controller.recotizarDetallesSubtotal.doCotizacion]");
        // aplicamos la promoción
        var queryParams = {
          'aplicar_promocion[cantidad]': detalle.get('cantidad'),
          'aplicar_promocion[caliente]': detalle.get('caliente'),
          'aplicar_promocion[codigo]': producto.get('codigoBarra'),
          'aplicar_promocion[ruc]': self.get('ruc'),
          'aplicar_promocion[sucursal_id]': model.get('sucursal').get('id')
        };

        var montoCotizacion = parseFloat(detalle.get('montoCotizacion'));

        if (!detalle.get('id')) {
          montoCotizacion = cotizacion.get('monto');
        }

        console.log("[ventas_controller.recotizarDetallesSubtotal] Seteando moneda a model");
        if (moneda) {
          console.log(moneda);
          model.set('moneda', moneda);
          queryParams['aplicar_promocion[moneda_id]'] = moneda.get('id');
          queryParams['aplicar_promocion[moneda_producto_id]'] = detalle.get('moneda').get('id');
        }

        if (tarjeta) {
          queryParams['aplicar_promocion[tarjeta_id]'] = tarjeta.get('id');
        }

        detalle.set('multiplicar', multiplicar);

        if (!detalle.get('multiplicar')) {
          montoCotizacion = 1 / montoCotizacion;
        }
        detalle.set('montoCotizacion', montoCotizacion);
        queryParams['aplicar_promocion[monto_cotizacion]'] = montoCotizacion;

        var productos = self.store.find('producto', queryParams);

        productos.then(function() {
          var producto = productos.objectAt(0);
          detalle.set('descuento', producto.get('descuento') || 0);

          if (producto._data.promocion_aplicada) {
            var promoStore = self.store.getById('promocion', producto._data.promocion_aplicada.id);
            var promocion = null;

            if (promoStore) {
              promocion = promoStore;
            } else {
              promocion = self.store.createRecord('promocion', producto._data.promocion_aplicada);
              promocion.transitionTo('saved');
            }
            detalle.set('promocion', promocion);
            promocion.set('tipo', producto._data.promocion_aplicada.tipo);
          }
          // actualizamos el detalle
          var subtotalCotizado = detalle.get('precio') * detalle.get('cantidad') * montoCotizacion;
          subtotalCotizado.toFixed(2);
          detalle.set('descuento', detalle.get('descuento').toFixed(2) || 0);
          subtotalCotizado = subtotalCotizado - detalle.get('descuento');
          subtotalCotizado = subtotalCotizado.toFixed(2);
          detalle.set('cotizacion', cotizacion);
          detalle.set('multiplicar', multiplicar);
          detalle.set('subtotalCotizado', subtotalCotizado);
        });
      }

      detalle.get('moneda').then(function() {
        self.buscarCotizacion(moneda, detalle.get('moneda').get('content'), doCotizacion);
      });
    });

    //}
  }.observes('monedaSeleccionada', 'tarjetaSeleccionada', 'sucursalSeleccionada'),

  /**
   * Busca la cotizacion para la moneda y monedaBase. Callback es un funcion que recibe
   * como primer parámetro la cotizacion y segundo parámetro un boolean que indica si se
   * debe multiplicar o no
   **/
  buscarCotizacion: function(monedaBase, moneda, callback) {
    console.log('ventas_controller.buscarCotizacion');
    var self = this;

    if (!monedaBase || !moneda) {
      return;
    }
    var params = {
      moneda_id: moneda.get('id'),
      moneda_base_id: monedaBase.get('id')
    };
    var cotizaciones = self.store.find('cotizacion', { ultima_cotizacion: params });
    cotizaciones.then(function() {
      var cotizacion = cotizaciones.objectAt(0);
      if (cotizacion) {
        callback(cotizacion, true);
      } else {
        // buscamos el otro sentido de la cotización
        params = {
          moneda_id: monedaBase.get('id'),
          moneda_base_id: moneda.get('id')
        };
        cotizaciones = self.store.find('cotizacion', { ultima_cotizacion: params });
        cotizaciones.then(function() {
          cotizacion = cotizaciones.objectAt(0);
          callback(cotizacion, false);
        });
      }
    });
  },

  clearProducto: function() {
    console.log("VentasBaseController->clearProducto");
    if (!this.get('agregandoDetalle')) {
      this.set('productoSeleccionado', null);
      this.set('descripcionSW', '');
      var detalle = this.get('detNuevo');
      this.set('montoCotizacionAjustado', 0);
      if (detalle) {
        detalle.set('cantidad', 1);
        detalle.set('producto', null);
        detalle.set('precio', 0);
        detalle.set('descuento', 0);
        detalle.set('promocion', null);
        detalle.set('subtotalCotizado', 0);
        detalle.set('montoCotizacion', 0);
        detalle.set('moneda', null);
      }
    }
  },

  loadFromSearchWidget: function() {
    //console.log("VentasBaseController->loadFromSearchWidget");
    if (!this.get('agregandoDetalle')) {
      //console.log("VentasBaseController->loadFromSearchWidget agregandoDetalle false");
      var productoSeleccionado = this.get('productoSeleccionadoSW');
      ////console.log(productoSeleccionado);
      if (productoSeleccionado && productoSeleccionado.get('id') !== null) {
        var codigoBarraSW = productoSeleccionado.get('codigoBarra');
        this.set('codigoBarra', codigoBarraSW);
        this.loadProducto();
      }
    }
  }.observes('productoSeleccionadoSW'),

  checkExistencia: function() {
    var self = this;
    //console.log("VentasBaseController->checkExistencia");
    if (!this.get('agregandoDetalle')) {
      var producto = this.get('productoSeleccionado');
      var detalle = this.get('detNuevo');
      var detalles = this.get('detalles');
      var feedback = this.get('feedback');
      var existenciaEnDetalles = 0;
      var existencia = 0;

      //console.log("chek ");
      if (producto) {
        var tipoProducto = producto.get('tipoProducto');

        tipoProducto.then(function() {
          if (tipoProducto.get('servicio')) {
            detalle.set('caliente', false);
            feedback.set('existencia', null);
            self.set('existencia', 'Es servicio');
            return;
          }
        });


        var productoId = producto.get('id');
        if (producto.get('pack')) {
          productoId = producto.get('data.producto.id');
        }

        if (detalles) {
          detalles.forEach(function(detalle) {
            //console.log(detalle.get('id'));

            if (detalle !== null && !detalle.get('id')) {

              var idProducto = detalle.get('producto.id');
              var idProductoPack = detalle.get('producto.data.producto.id');

              if (idProducto == productoId) {
                existenciaEnDetalles += parseFloat(detalle.get('cantidad'));
              } else if (idProductoPack == productoId) {
                existenciaEnDetalles += parseFloat(detalle.get('cantidad') * detalle.get('producto.cantidad'));
              }
            }
          });
        }

        if (producto.get('pack')) {
          existenciaEnDetalles = Math.floor(existenciaEnDetalles / parseFloat(producto.get('data.cantidad')));
        }

        existencia = producto.get('data.existencia') - existenciaEnDetalles;
        self.set('existenciaActual', existencia);
        self.set('existencia', 'Total ' + existencia);
        if (detalle) {

          if (detalle !== null) {
            var cantidad = detalle.get('cantidad');
            if (!cantidad) {
              feedback.set('existencia', "Debe ingresar una cantidad mayor a 0");
            } else if (existencia < cantidad) {
              feedback.set('existencia', "Solo existen " + existencia);
              //this.set("errors", errors);
            } else {
              feedback.set('existencia', null);
            }
          }

        } else {
          feedback.set('existencia', null);
          self.set('existencia', null);
        }

      } else {
        feedback.set('existencia', null);
        self.set('existencia', null);
      }

      self.set('existenciaDirty', existencia);
    }

  }.observes('detNuevo.cantidad', 'productoSeleccionado'),

  checkPromocion: function() {
    //console.log("VentasBaseController->checkPromocion");
    var producto = this.get('productoSeleccionado');
    var detalle = this.get('detNuevo');
    var feedback = this.get('feedback');
    var promocion = null;

    if (detalle) {
      promocion = detalle.get('promocion');
    }

    if (promocion) {
      ////console.log("promocion!!!");
      console.log(promocion);

      feedback.set('promocion', "Promo " + promocion.get('tipo') + ": " + promocion.get('descripcion'));
    } else {
      feedback.set('promocion', "");
    }

  }.observes('detNuevo.promocion'),

  checkNullos: function() {
    //console.log("VentasBaseController->checkNullos");
    if (!this.get('agregandoDetalle')) {
      var detalle = this.get('detNuevo');
      var descripcionSW = this.get('descripcionSW');
      $('.tt-input').val(descripcionSW);
      //console.log(descripcionSW);

      if (detalle) {

        var precio = detalle.get('precio'),
          cantidad = detalle.get('cantidad'),
          descuento = detalle.get('descuento'),
          producto = detalle.get('producto');

        if (!precio) {
          if (producto) {
            ////console.log("reset precio");
            detalle.set('precio', producto.get('precio'));
          } else {
            detalle.set('precio', 0);
          }
        }
        /*
        if (!cantidad) {
            detalle.set('cantidad', 1);
        }
        */
        if (!descuento) {
          if (producto) {
            detalle.set('descuento', producto._data.descuento || 0);
          } //else {
          //    detalle.set('descuento', 0);
          //}
        }
      }
      //this.set('descripcionSW', descripcionSW);
    }

  }.observes('detNuevo.cantidad', 'detNuevo.precio'),


  checktotalfinal: function() {
    if (!this.get('medioPagoDetalles')) {
      this.set('saldoMedios', this.get('totalFinal'));
      this.set('saldoMediosUnico', this.get('totalFinal'));
      this.set('saldoMediosUnicoTemp', this.get('totalFinal'));


    }
  }.observes('totalFinal'),

  medioPagoObserver: function() {
    var medioPago = this.get('medioPagoSeleccionado');
    var CODIGO_TARJETA_CREDITO = this.get('CODIGO_TARJETA_CREDITO');
    var CODIGO_TARJETA_DEBITO = this.get('CODIGO_TARJETA_DEBITO');
    var model = this.get('model');

    if (medioPago) {
      model.set('medioPago', medioPago);
      // si el medio de pago es tarjeta de credito, mostrar el combo de tarjetas
      if (medioPago.get('codigo') === CODIGO_TARJETA_CREDITO) {

        var tarjetas = this.get('tarjetasDeCredito');
        if (tarjetas) {
          this.set('esMedioPagoTarjetaCredito', true);
          this.set('tarjetas', tarjetas);
          this.set('tarjetaSeleccionada', tarjetas.objectAt(0));
        }
      } else if (medioPago.get('codigo') === CODIGO_TARJETA_DEBITO) {
        var tarjetas = this.get('tarjetasDeDebito');
        if (tarjetas) {
          this.set('esMedioPagoTarjetaCredito', true);
          this.set('tarjetas', tarjetas);
          this.set('tarjetaSeleccionada', tarjetas.objectAt(0));
        }
      } else {
        this.set('esMedioPagoTarjetaCredito', false);
        this.set('tarjetaSeleccionada', null);
      }
    } else {
      model.set('medioPago', null);
    }
  }.observes('medioPagoSeleccionado'),

  medioPagoObserverModal: function() {
    var medioPago = this.get('medioPagoSeleccionadoModal');
    var CODIGO_TARJETA_CREDITO = this.get('CODIGO_TARJETA_CREDITO');
    var CODIGO_TARJETA_DEBITO = this.get('CODIGO_TARJETA_DEBITO');
    var model = this.get('model');
    var unicoMedio = this.get('unicoMedioPago');
    var medioPagoSeleccionado = this.get('medioPagoSeleccionado');
    if (unicoMedio) {
      this.set('medioPagoSeleccionadoModal', medioPagoSeleccionado);
      if (this.get('tarjetaSeleccionada')) {
        this.set('tarjetaSeleccionadaModal', this.get('tarjetaSeleccionada'));
        this.set('esMedioPagoTarjetaCreditoModal', this.get('esMedioPagoTarjetaCredito'));
      }

    } else {
      if (medioPago) {
        //            model.set('medioPago', medioPago);
        // si el medio de pago es tarjeta de credito, mostrar el combo de tarjetas
        if (medioPago.get('codigo') === CODIGO_TARJETA_CREDITO) {

          var tarjetas = this.get('tarjetasDeCreditoModal');
          if (tarjetas) {
            this.set('esMedioPagoTarjetaCreditoModal', true);
            this.set('tarjetasModal', tarjetas);
            this.set('tarjetaSeleccionadaModal', tarjetas.objectAt(0));
          }
        } else if (medioPago.get('codigo') === CODIGO_TARJETA_DEBITO) {
          var tarjetas = this.get('tarjetasDeDebito');
          if (tarjetas) {
            this.set('esMedioPagoTarjetaCreditoModal', true);
            this.set('tarjetasModal', tarjetas);
            this.set('tarjetaSeleccionadaModal', tarjetas.objectAt(0));
          }
        } else {
          this.set('esMedioPagoTarjetaCreditoModal', false);
          this.set('tarjetaSeleccionadaModal', null);
        }
      }
    }
    console.log("Seteando focus en ventaMedio.saldoMedios");
    $('#ventaMedio').on('shown.bs.modal', function() {
      $('#saldoMedios').focus();
    })
  }.observes('medioPagoSeleccionadoModal', 'unicoMedioPago'),


  //    setCreditoFalse: function(){
  //        this.set('credito',false);
  //
  //    }.observes('unicoMedioPago'),


  habilitarAgregarMediosUnico: function() {
    saldo = Number(this.get('saldoMediosUnico'));
    total = Number(this.get('totalFinal'));
    if (total - saldo <= 0 && !(this.get('medioPagoDetalles'))) {
      this.set('permitirAgregarMedios', false);
    } else {
      this.set('permitirAgregarMedios', true);
    }
  }.observes('saldoMediosUnico'),

  tarjetaObserver: function() {
    var tarjeta = this.get('tarjetaSeleccionada');
    var model = this.get('model');
    model.set('tarjeta', tarjeta);
  }.observes('tarjetaSeleccionada'),

  loadRecargo: function() {
    var medioPagoSeleccionado = this.get('medioPagoSeleccionado');
    var tipoCreditoSeleccionado = this.get('tipoCreditoSeleccionado');
    var cantidadCuotasTmp = this.get('cantidadCuotasTmp');
    var self = this;
    var feedback = this.get('feedback');
    var soportaRecargo = true;

    var parametros = self.get('parametros');
    if (!parametros || !parametros.get('recargoPrecioVenta')) {
      console.log("Poniendo soporte de RECARGOS a false");
      soportaRecargo = false;
    }
    if (soportaRecargo && medioPagoSeleccionado && tipoCreditoSeleccionado) {

      var params = {
        'by_medio_pago': medioPagoSeleccionado.get('id'),
        'unpaged': true
      };

      if (self.get('credito')) {
        var tipoCredito = self.get('tipoCreditoContado');
        params['by_tipo_credito'] = tipoCreditoSeleccionado.get('id');
        params['by_cantidad_cuotas'] = self.get('cantidadCuotasTmp');
      }

      var recargos = self.store.find('recargo', params);

      recargos.then(function(response) {
        var medioPagoSeleccionado = self.get('medioPagoSeleccionado');
        var tipoCreditoSeleccionado = self.get('tipoCreditoSeleccionado');
        var cantidadCuotasTmp = self.get('cantidadCuotasTmp');

        var tipoCredito = self.get('tipoCreditoContado');
        if (self.get('credito')) {
          tipoCredito = tipoCreditoSeleccionado;
        }
        if ((!response.query.by_medio_pago || response.query.by_medio_pago === medioPagoSeleccionado.get('id')) && (!response.query.by_tipo_credito || response.query.by_tipo_credito === tipoCredito.get('id')) && (!response.query.by_cantidad_cuotas || response.query.by_cantidad_cuotas === self.get('cantidadCuotasTmp'))) {
          var recargo = response.objectAt(0);
          console.log(recargos);
          console.log(response);
          if (recargo && recargo._data.cantidadCuotas == self.get('cantidadCuotasTmp')) {
            console.log("Cargando recargo!");
            self.set('recargo', recargo)
          } else if (recargo) {
            Bodega.Notification.show('Atención!', 'No está definido un recargo para la cantidad de cuotas seleccionada', Bodega.Notification.WARNING_MSG);
          } else {
            Bodega.Notification.show('Cuidado!', 'No existe recargo para el medio de pago y el tipo de crédito seleccionados', Bodega.Notification.WARNING_MSG);
            self.set('recargo', null);
          }

        }

      });
    }
    /*else
    {
      feedback.set('recargoRequerido', "No existe recargo para el medio de pago y el tipo de crédito seleccionados");
    }*/
  }.observes('cantidadCuotasTmp', 'medioPagoSeleccionado', 'tipoCreditoSeleccionado'),



  actions: {

    checkCredencialesVentaDetalle: function(det) {
      console.log(det);
      var detalle = det;
      var credentials = { identification: this.get('identificationBorrarDetalle'), password: this.get('passwordBorrarDetalle') };
      console.log(credentials);
      this.set('passwordUsuario', null);
      var self = this;
      $.ajax({
        url: '/api/v1/session',
        type: 'POST',
        data: {
          'username': credentials.identification,
          'password': credentials.password,
          'check_only': 1
        },
        accepts: 'application/json',
        success: function(data) {
          self.set('identification', null);
          $('.modal').modal('hide');
          self.send('removeModal');
          $('body').removeClass('modal-open');
          if ($.inArray('FE_delete_venta_detalle', data.permisos) >= 0) {
            console.log(data.permisos);
            self.send('borrarDetalle', detalle);
          } else {
            Bodega.Notification.show('Error', 'El usuario no esta autorizado a eliminar detalles de venta', Bodega.Notification.ERROR_MSG);
            //                       self.set('errorMessage', '');
          }

        },
        error: function() {
          self.set('errorMessage', 'Credenciales no válidas');
        }
      });
    },

    agregarDetalle: function() {
      console.log("Agregando detalle");
      var producto = this.get('productoSeleccionado');
      var detalle = this.get('detNuevo');
      var feedback = this.get('feedback');
      var descuento = detalle.get('descuento');
      console.log('DESCUENTO');
      console.log(descuento);
      var maxDetalles = this.get('maxDetalles');
      var detalles = this.get('detalles');
      var cantidadDetalles = 0;
      var loteSeleccionadoModal = this.get('loteSeleccionadoModal');
      var self = this;
      self.set('count', 0);
      if (detalles) {
        cantidadDetalles = detalles.content.length;

        if (!this.get('soportaImpresionFacturaVenta') && cantidadDetalles > maxDetalles) {
          Bodega.Notification.show('Atención', 'Límite de detalles para la hoja de impresión alcanzado', Bodega.Notification.WARNING_MSG);
          return;
        }
      } else {
        console.log("No existen los detalles!!");
        return;
      }

      if (producto && !feedback.get('existencia')) {
        this.set('agregandoDetalle', true);
        //establecer el producto al nuevo detalle.
        detalle.set('producto', producto);
        producto.get('moneda').then(function(moneda) {
          detalle.set('moneda', moneda);
        });

        if (!descuento) {
          detalle.set('descuento', 0);
        }
        //adjuntar a la lista de detalles
        if (this.get('habilitaLote')) {
          if (loteSeleccionadoModal) {
            if (loteSeleccionadoModal.get('cantidad') < detalle.get('cantidad')) {
              Bodega.Notification.show('Atención', 'No existen ' + detalle.get('cantidad') + 'en el lote seleccionado', Bodega.Notification.WARNING_MSG);
              return;
            }
            var lote = loteSeleccionadoModal.get('lote');
            lote.then(function() {
              detalle.set('loteId', lote.get('id'));
              console.log(detalle.get('loteId'));
            });

          }

        } else {
          detalle.set('codigoLote', "loteUnico" + producto.get('id'));
        }

        this.set('descripcionSW', '');
        this.set('detNuevo', this.store.createRecord('ventaDetalle'));
        detalles.addRecord(detalle);
        detalle.set('dirty', false);
        this.set('habilitaLote', false);
        this.get('loteSeleccionadoModal', null);
        this.set('productoSeleccionado', null);
        this.set('productoSeleccionadoSW', null);
        this.get('controllers.application').set('containerHeight', Bodega.newHeightWrapper(true));
        this.set('codigoBarra', null);
        this.set('agregandoDetalle', false);
        this.clearProducto();
        this.set('existencia', null);
        $("#codigoBarra").focus();
      }


      this.set('count', 0);

    },

    borrarDetalle: function(detalle) {
      console.log(detalle);
      //            console.log("VentasBaseController->action->borrarDetalle detalle:"+detalle);
      //            console.log("borrarDetalle %o", detalle);
      this.get('detalles').removeRecord(detalle);
      this.get('controllers.application').set('containerHeight', Bodega.newHeightWrapper());

      //detalle.deleteRecord();
      ////console.log("borrarDetalle", this.get('indice'));
    },

    borrarDetalleMedio: function(detalle, monto) {
      //console.log("VentasBaseController->action->borrarDetalle detalle:"+detalle);
      ////console.log("borrarDetalle %o", detalle);
      console.log(monto);
      var self = this;
      if (this.get('unicoMedioPago')) {
        this.set('saldoMediosUnico', this.get('totalFinal'));
      }

      this.set('saldoMedios', this.get('saldoMediosTemp') + Number(monto));
      this.set('saldoMediosTemp', this.get('saldoMediosTemp') + Number(monto));
      this.get('detallesMedio').removeRecord(detalle);
      if (this.get('detallesMedio.content.length') == 0) {
        self.set('medioPagoDetalles', false);
      }
      this.get('controllers.application').set('containerHeight', Bodega.newHeightWrapper());

      self.set('permitirAgregarMedios', false);
      //detalle.deleteRecord();
      ////console.log("borrarDetalle", this.get('indice'));
    },

    cargarMedios: function() {
      var self = this;
      var detalle = this.get('detMedioNuevo');
      var detalles = this.get('detallesMedio');
      var CODIGO_TARJETA_CREDITO = this.get('CODIGO_TARJETA_CREDITO');
      var CODIGO_TARJETA_DEBITO = this.get('CODIGO_TARJETA_DEBITO');
      var medioPagoSeleccionado = self.get('medioPagoSeleccionadoModal');
      var medioPagoSeleccionadoUnico = self.get('medioPagoSeleccionado');

      console.log('saldoMediosTemp',this.get('saldoMediosTemp'));
      console.log('medioPagoDetalles',this.get('medioPagoDetalles'));
      if (this.get('unicoMedioPago')) {
        saldoTemp = self.get('totalFinal') - self.get('saldoMediosUnico');
        if (saldoTemp <= 0 && !self.get('medioPagoDetalles')) {
          detalle.set('monto', self.get('totalFinal'));
          detalle.set('medioPago', medioPagoSeleccionadoUnico);
          if (medioPagoSeleccionadoUnico.get('codigo') == CODIGO_TARJETA_CREDITO || medioPagoSeleccionadoUnico.get('codigo') == CODIGO_TARJETA_DEBITO) {
            detalle.set('tarjeta', self.get('tarjetaSeleccionada'));
          } else {
            detalle.set('tarjeta', null);
          }
          self.set('detMedioNuevo', self.store.createRecord('ventaMedio'));
          detalles.addRecord(detalle);
          if (!(saldoTemp == 0)) {
            detalle.set('vuelto', Number(saldoTemp) * -1);
            self.set('vuelto', Number(saldoTemp) * -1);
          }
          self.set('permitirAgregarMedios', true);
          self.set('medioPagoDetalles', true);

        }
      } else {
        if (!self.get('medioPagoDetalles')) {

          saldoTemp = self.get('totalFinal') - self.get('saldoMedios');


          if (saldoTemp >= 0 && saldoTemp != self.get('totalFinal')) {
            self.set('medioPagoDetalles', true);
            detalle.set('monto', self.get('saldoMedios'));
            detalle.set('medioPago', medioPagoSeleccionado);
            if (medioPagoSeleccionado.get('codigo') == CODIGO_TARJETA_CREDITO || medioPagoSeleccionado.get('codigo') == CODIGO_TARJETA_DEBITO) {
              detalle.set('tarjeta', self.get('tarjetaSeleccionadaModal'));
            } else {
              detalle.set('tarjeta', null);
            }
            self.set('detMedioNuevo', self.store.createRecord('ventaMedio'));
            detalles.addRecord(detalle);
            self.set('saldoMedios', saldoTemp);
            self.set('saldoMediosTemp', saldoTemp);
          } else if (saldoTemp < 0) {
            self.set('saldoMedios', 0);
            self.set('saldoMediosTemp', 0);
            detalle.set('medioPago', medioPagoSeleccionado);
            detalle.set('monto', self.get('totalFinal'));
            if (medioPagoSeleccionado.get('codigo') == CODIGO_TARJETA_CREDITO || medioPagoSeleccionado.get('codigo') == CODIGO_TARJETA_DEBITO) {
              detalle.set('tarjeta', self.get('tarjetaSeleccionadaModal'));
            } else {
              detalle.set('tarjeta', null);
            }
            detalle.set('vuelto', Number(saldoTemp) * -1);
            self.set('vuelto', Number(saldoTemp) * -1);
            self.set('detMedioNuevo', self.store.createRecord('ventaMedio'));
            detalles.addRecord(detalle);
            self.set('permitirAgregarMedios', true);
          }
        } else if (self.get('saldoMediosTemp') != 0) {
          saldoTemp = self.get('saldoMediosTemp') - self.get('saldoMedios');
          if (saldoTemp >= 0) {
            detalle.set('monto', self.get('saldoMedios'));
            detalle.set('medioPago', medioPagoSeleccionado);
            if (medioPagoSeleccionado.get('codigo') == CODIGO_TARJETA_CREDITO || medioPagoSeleccionado.get('codigo') == CODIGO_TARJETA_DEBITO) {
              detalle.set('tarjeta', self.get('tarjetaSeleccionadaModal'));
            } else {
              detalle.set('tarjeta', null);
            }
            self.set('detMedioNuevo', self.store.createRecord('ventaMedio'));
            detalles.addRecord(detalle);
            self.set('saldoMedios', saldoTemp);
            self.set('saldoMediosTemp', saldoTemp);
          } else if (saldoTemp < 0) {
            self.set('saldoMedios', 0);
            detalle.set('vuelto', Number(saldoTemp) * -1);
            self.set('vuelto', Number(saldoTemp) * -1);
            detalle.set('medioPago', medioPagoSeleccionado);
            detalle.set('monto', self.get('saldoMediosTemp'));
            if (medioPagoSeleccionado.get('codigo') == CODIGO_TARJETA_CREDITO || medioPagoSeleccionado.get('codigo') == CODIGO_TARJETA_DEBITO) {
              detalle.set('tarjeta', self.get('tarjetaSeleccionadaModal'));
            } else {
              detalle.set('tarjeta', null);
            }
            self.set('saldoMediosTemp', 0);
            self.set('detMedioNuevo', self.store.createRecord('ventaMedio'));
            detalles.addRecord(detalle);
            self.set('permitirAgregarMedios', true);
          }
        }
      }
      if (saldoTemp == 0) {
        self.set('permitirAgregarMedios', true);
        console.log("Seteando focus en ventaMedio.facturaButton");
        $('#facturaButton').focus();
      }
    },

    save: function() {
      console.log("VENTAS_CONTROLLER_NEW: SAVE");
      var model = this.get('model');
      var self = this;
      var feedback = this.get('feedback');

      if (feedback.get('clienteRequerido')) {
        Bodega.Notification.show('Error', 'Seleccione un cliente si es venta a crédito', Bodega.Notification.ERROR_MSG);
        return;
      }
      //si se cargó cliente, hay que anular nombreCliente
      if (this.get('clienteExistente')) {
        this.set('nombreCliente', null);
        this.set('ruc', null);
      }

      if (this.get('esCampanha')) {
        model.set('persona', this.get('personaEmpresa'));
        model.set('campanha', this.get('campanhaSeleccionada'));
      }

      if (this.get('esMision')) {
        model.set('persona', this.get('personaEmpresa'));
        model.set('campanha', this.get('campanhaSeleccionadaSI'));
      }

      if (this.get('esConsultorio')) {
        model.set('persona', this.get('personaEmpresa'));
        model.set('colaborador', this.get('colaboradorSeleccionado'));
        model.set('consultorio', this.get('consultorioSeleccionado'));
      }

      if (this.get('esPaciente')) {
        console.log(this.get('pacienteSeleccionado'));
        var persona = this.store.find('persona', { by_razon_social: this.get('pacienteSeleccionado.infoPaciente') });
      }


      var detalles = this.get('detalles');
      var detallesMedio = this.get('detallesMedio');

      if (!this.get('muestraMedios')) {
        var detalleMedioTemp = this.get('detMedioNuevo');

        detalleMedioTemp.set('monto', self.get('totalFinal'));
        detalleMedioTemp.set('medioPago', self.get('medioPagoSeleccionado'));
        detallesMedio.addRecord(detalleMedioTemp);
      }

      model.set('tipo_salida', this.get('tipoSalida'));


      var cambioSinPermiso = false;

      var actualizando = false;
      detalles.forEach(function(d) {
        var cambioPrecio = d.get('precio') != d.get('producto').get('precio');
        var cambioDescuento = d.get('descuento') != d.get('producto')._data.descuento;
        var dirty = d.get('dirty');

        if (dirty) {
          actualizando = true;
        } else {
          actualizando = false;
        }

        /*if((cambioPrecio || cambioDescuento) &&
            self.get('disablePrecio')) {
            cambioSinPermiso = true;
            Bodega.Notification.show('Error', 'Los montos de la venta fueron editados sin autorización.', Bodega.Notification.ERROR_MSG);
        }*/
      });

      if (actualizando) {
        Bodega.Notification.show('Espere!', 'Actualizando detalles', Bodega.Notification.ERROR_MSG);
        return;
      }

      if (detalles.get('length') > 0 && !cambioSinPermiso) {

        if (!this.get('credito') && detallesMedio.get('length') == 0) {
          Bodega.Notification.show('Error', 'Debe ingresar por lo menos un medio de pago para la Venta', Bodega.Notification.ERROR_MSG);
          return;
        }

        model.set('total', parseFloat(this.get('totalFinal')).toFixed(2));
        model.set('descuento', parseFloat(this.get('descuentoTotal')).toFixed(2));
        model.set('iva10', parseFloat(this.get('iva10Total')).toFixed(2));
        model.set('iva5', parseFloat(this.get('iva5Total')).toFixed(2));
        model.set('ganancia', parseFloat(this.get('calcularGanancia')).toFixed(2));
        model.set('cantidadCuotas', this.get('cantidadCuotasTmp'));
        model.set('descuentoRedondeo', this.get('campoDescuentoRedondeo'));
        model.set('nombreCliente', this.get('nombreCliente'));
        model.set('rucCliente', this.get('ruc'));
        var tipoCredito = this.get('tipoCreditoSeleccionado');

        if (!this.get('credito')) {
          $('.modal').modal('hide');
          $('body').removeClass('modal-open');
        } else {
          if (tipoCredito) {
            model.set('tipoCredito', tipoCredito);
          } else {
            tipoCredito = this.get('tipoCreditoDefault');
            model.set('tipoCredito', tipoCredito);
          }

          var tarjetaCredito = this.get('tarjetaCredito');
          model.set('tarjetaCredito', tarjetaCredito);
        }


        var vendedor = this.get('vendedorSeleccionado');
        model.set('vendedor', vendedor);

        var empresa = this.get('empresaSeleccionada');
        //console.log("sucursalSeleccionada" + this.get('sucursalSeleccionada').get('descripcion'));
        //console.log("model.sucursal" + model.get('sucursal').get('descripcion'));
        var sucursal = this.get('sucursalSeleccionada');
        model.set('sucursal', sucursal);
        //model.set('tipoCredito', tipoCredito);

        if (!this.get('editando')) {
          var recargo = this.get('recargo');
          if (recargo) {
            model.set('porcentajeRecargo', recargo.get('interes'));
          }
        }

        Bodega.Utils.disableElement('.btn');

        if (self.get('esPaciente')) {
          persona.then(function(response) {
            model.set('persona', response.objectAt(0));
            model.save().then(function(response) {
                var parametros = self.get('parametros');
                // if (!parametros.get('soportaCajaImpresion') && parametros.get('soportaImpresionFacturaVenta')) {
                //   self.imprimirFactura(response);
                // }

                self.transitionToRoute('/ventas?tipo_salida=clientes').then(function() {
                  Bodega.Notification.show('Éxito', 'Venta creada');
                  Bodega.Utils.enableElement('.btn');
                });
              },
              function(response) {
                var faltaStock = response.errors.base;
                if (faltaStock) {
                  for (var i = 0; i < faltaStock.length; i++) {
                    Bodega.Notification.show('Error', faltaStock[i], Bodega.Notification.ERROR_MSG);
                    Bodega.Utils.enableElement('.btn');
                  }
                } else {
                  Bodega.Notification.show('Error', 'Ha ocurrido un error al guardar la venta', Bodega.Notification.ERROR_MSG);
                  Bodega.Utils.enableElement('.btn');
                }
              });
          });
        } else {
          model.save().then(function(response) {
              var parametros = self.get('parametros');
              // if (!parametros.get('soportaCajaImpresion') && parametros.get('soportaImpresionFacturaVenta')) {
              //   self.imprimirFactura(response);
              // }

              self.transitionToRoute('/ventas?tipo_salida=clientes').then(function() {
                Bodega.Notification.show('Éxito', 'Venta creada');
                Bodega.Utils.enableElement('.btn');
              });
            },
            function(response) {
              var faltaStock = response.errors.base;
              if (faltaStock) {
                for (var i = 0; i < faltaStock.length; i++) {
                  Bodega.Notification.show('Error', faltaStock[i], Bodega.Notification.ERROR_MSG);
                  Bodega.Utils.enableElement('.btn');
                }
              } else {
                Bodega.Notification.show('Error', 'Ha ocurrido un error al guardar la venta', Bodega.Notification.ERROR_MSG);
                Bodega.Utils.enableElement('.btn');
              }
            });
        }

      } else if (detalles.get('length') == 0) {
        Bodega.Notification.show('Atención', 'No agregó detalles, no se puede guardar la venta', Bodega.Notification.WARNING_MSG);
      }
    },

    saveInterno: function() {
      //console.log("VentasBaseController->action->saveInterno");
      var model = this.get('model');
      model.set('usoInterno', true);
      this.send('save');
    },

    cancel: function() {
      //console.log("VentasBaseController->action->cancel");
      this.transitionToRoute('/ventas?tipo_salida=clientes');
    },
    cerrarModal: function() {
      $('.modal').modal('hide');
    },
    cargarProducto: function() {
      //console.log("VentasBaseController->action->cargarProducto");
      self = this;
      var producto = this.get('productoSeleccionado');





      if (producto) {
        this.send('agregarDetalle');
      } else {
        this.loadProducto();
      }

    },

    contarEnters: function() {
      console.log("VentasBaseController->action->contarEnters");
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
    }.observes('codigoBarra')

  }
});

Bodega.VentasNewController = Bodega.VentasBaseController.extend({
  formTitle: 'Nueva Salida',

  clienteConPromocion: false,

  esDonacion: false,
  esCampanha: false,

  // loadCliente: function() {
  //     console.log("VentasBaseController->loadCliente");
  //     var ruc = this.get('ruc');
  //     var self = this;
  //     var model = self.get('model');
  //     var clienteActual = self.get('cliente');
  //     var feedback = this.get('feedback');
  //     var clienteCargado = this.get('clienteCargado');
  //     console.log("---CLIENTE CARGADO---" + clienteCargado);
  //
  //     ////console.log(ruc);
  //     if (ruc && !clienteCargado) {
  //         var clientes = this.store.find('cliente', {
  //             'ruc': ruc
  //         });
  //
  //         clientes.then(function() {
  //           console.log(clientes);
  //             var cliente = clientes.objectAt(0);
  //             if (cliente) {
  //                 //self.set('nombre', cliente.get('nombre'));
  //                 //self.set('apellido', cliente.get('apellido'));
  //                 self.set('clienteActual', cliente);
  //                 self.set('clienteExistente', true);
  //                 model.set('cliente', cliente);
  //                 if (cliente.get('ruc') !== "0") {
  //                     feedback.set('clienteRequerido', null);
  //                 }
  //             } else if (clienteActual) {
  //                 model.set('cliente', null);
  //                 self.set('clienteActual', null);
  //                 self.set('clienteExistente', false);
  //                 if (model.get('credito')) {
  //                     feedback.set('clienteRequerido', "Debe seleccionar un cliente si es Venta Crédito");
  //                 }
  //             }
  //             self.updateDetalles();
  //         });
  //
  //     } else {
  //         this.set('clienteCargado', false);
  //         if (clienteActual) {
  //
  //             model.set('cliente', null);
  //             self.set('clienteActual', null);
  //             self.updateDetalles();
  //         }
  //         this.set('clienteExistente', false);
  //     }
  // },

  observeCliente: function() {
    console.log('entracliente');
    var feedback = this.get('feedback');
    var self = this;
    var model = self.get('model');
    var clienteLabel = this.get('clienteLabel');
    var clienteSeleccionado = this.get('clienteSeleccionado');
    if (clienteSeleccionado) {
      console.log(clienteSeleccionado.get('idPersona'));

      if (clienteLabel == clienteSeleccionado.get('infoCliente')) {
        console.log("clienteLabel == clienteSeleccionado.get('infoCliente')" + (clienteLabel == clienteSeleccionado.get('infoCliente')));
        self.set('clienteActual', clienteSeleccionado);
        self.set('clienteExistente', true);
        model.set('cliente', clienteSeleccionado);
        if (clienteSeleccionado.get('ruc') !== "0") {
          feedback.set('clienteRequerido', null);

          var campanhas = self.store.find('campanha', { 'by_persona_id': clienteSeleccionado.get('idPersona') });
          campanhas.then(function(response) {
            self.set('campanhas', response);
            self.set('campanhaSeleccionada', response.objectAt(0));
            self.set('muestraCampanha', true);
          });
        }

      } else if (clienteLabel == '' || clienteLabel != clienteSeleccionado.get('infoCliente')) {
        console.log("clienteLabel == '' || clienteLabel != clienteSeleccionado.get('infoCliente')" + (clienteLabel == '' || clienteLabel != clienteSeleccionado.get('infoCliente')));
        self.set('nombreCliente', clienteLabel);
        self.set('muestraRUC', true);
        self.set('clienteExistente', false);
        model.set('clienteSeleccionado', null);
        model.set('cliente', null);
        self.set('clienteActual', null);
        self.set('muestraCampanha', false);
        self.set('campanhaSeleccionada', null);


        if (model.get('credito')) {
          feedback.set('clienteRequerido', "Debe seleccionar un cliente si es Venta Crédito");
        }
      }
    }
    console.log('clienteActual' + self.get('clienteActual'));


  }.observes('clienteLabel'),

  cargarCliente: function() {
    console.log('entraclienteseleccionado');
    var self = this;
    var clienteSeleccionado = this.get('clienteSeleccionado');
    if (clienteSeleccionado) {
      self.set('muestraRUC', false);
      // console.log(clienteSeleccionado.get('infoCliente'));
      this.set('clienteLabel', clienteSeleccionado.get('infoCliente'));
      $('#credito').focus();
    }
  }.observes('clienteSeleccionado'),



  loadGarante: function() {
    console.log("VentasNewController -> loadGarante");
    var ruc = this.get('rucGarante');
    var self = this;
    var model = self.get('model');
    var garanteActual = self.get('garante');
    var feedback = this.get('feedback');
    var garanteCargado = this.get('garanteCargado');
    console.log("--- GARANTE CARGADO ---" + garanteCargado);

    console.log("RUC GARANTE: " + ruc);
    if (ruc && !garanteCargado) {
      var clientes = this.store.find('cliente', {
        'ruc': ruc
      });

      clientes.then(function() {
        console.log("Buscando garante");
        var garante = clientes.objectAt(0);

        if (garante) {
          self.set('garanteActual', garante);
          self.set('garanteExistente', true);
          model.set('garante', garante);
          if (garante.get('ruc') !== "0") {
            feedback.set('garanteRequerido', null);
          }

        } else {
          model.set('garante', null);
          self.set('garanteActual', null);
          self.set('garanteExistente', false);
          //Validación garante credito
          if (model.get('credito')) {
            feedback.set('garanteRequerido', "Debe seleccionar un cliente existente como Garante");
          }
        }
        self.updateDetalles();
      });

    } else {
      this.set('garanteCargado', false);
      if (garanteActual) {

        model.set('garante', null);
        self.set('garanteActual', null);
        self.updateDetalles();
      }
      this.set('garanteExistente', false);
    }
  },

  loadVendedores: function() {
    var sucursal = this.get('sucursalSeleccionada');
    var self = this;
    var model = self.get('model');

    if (sucursal) {
      this.store.find('vendedor', { 'by_sucursal_id': sucursal.get('id'), 'by_activo': true, 'unpaged': true }).then(function(response) {
        self.set('vendedores', response);
        if (response.objectAt(0)) {
          self.set('vendedorSeleccionado', response.objectAt(0));
          model.set('vendedor', response.objectAt(0));
        } else {
          self.set('vendedorSeleccionado', null);
          model.set('vendedor', null);
        }
      });
    } else {

      self.set('vendedores', null);
      self.set('vendedorSeleccionado', null);
      model.set('vendedor', null);
    }
  }.observes('sucursalSeleccionada'),

  updateDetalles: function() {
    //console.log("VentasBaseController->updateDetalles");
    var detalles = this.get('detalles');
    var self = this;
    var cliente = self.get('clienteActual');
    var reEvaluar = false;
    var moneda = self.get('monedaSeleccionada');
    var monedaID = moneda ? moneda.get('id') : null;
    var tarjeta = self.get('tarjetaSeleccionada');
    var tarjetaID = tarjeta ? tarjeta.get('id') : null;

    if (this.get('clienteConPromocion')) {
      reEvaluar = true;
    } else if (cliente && cliente.get('tienePromocion')) {
      reEvaluar = true;
    }

    if (cliente && cliente.get('tienePromocion')) {
      this.set('clienteConPromocion', true);
    } else {
      this.set('clienteConPromocion', false);
    }


    if (detalles && reEvaluar) {
      detalles.forEach(function(detalle, index) {
        detalle.set('dirty', true);
        var producto = detalle.get('producto');
        console.log("-----------------PRODUCTO------------------");
        console.log(producto);
        console.log("detalle producto codigoBarra: " + producto._data.codigoBarra);
        var queryParams = {
          'aplicar_promocion[cantidad]': detalle.get('cantidad'),
          'aplicar_promocion[caliente]': detalle.get('caliente'),
          'aplicar_promocion[codigo]': producto._data.codigoBarra,
          'aplicar_promocion[ruc]': self.get('ruc'),
          'sucursal_id': self.get('sucursalSeleccionada').get('id')
        };

        if (monedaID) {
          queryParams['aplicar_promocion[moneda_id]'] = monedaID;
        }

        if (tarjetaID) {
          queryParams['aplicar_promocion[tarjeta_id]'] = tarjetaID;
        }

        var productos = self.store.find('producto', queryParams);

        productos.then(function() {

          var producto = productos.objectAt(0);
          if (producto) {
            //console.log(producto._data.precio);
            //console.log(detalle.get('precio'));

            /*
            if (producto._data.precio != detalle.get('precio')) {
                Bodega.Notification.show('Atención', 'Precio de "' + producto.get('descripcion') + '" modificado', Bodega.Notification.WARNING_MSG);
            }
            detalle.set('precio', producto.get('precio'));
            */

            //detalle.set('descuento', producto.get('descuento'));
            if (detalle.get('promocion')) {
              detalle.set('descuento', 0);
              detalle.set('promocion', null);
            }

            if (producto._data.promocion_aplicada) {
              if (producto._data.descuento > detalle.get('descuento')) {
                Bodega.Notification.show('Atención', 'Descuento de "' + producto.get('descripcion') + '" modificado', Bodega.Notification.WARNING_MSG);
                detalle.set('descuento', producto._data.descuento);
                var promoStore = self.store.getById('promocion', producto._data.promocion_aplicada.id);
                var promocion = null;
                if (promoStore) {
                  promocion = promoStore;
                } else {
                  promocion = self.store.createRecord('promocion', producto._data.promocion_aplicada);
                  promocion.transitionTo('saved');
                }

                detalle.set('promocion', promocion);
                promocion.set('tipo', producto._data.promocion_aplicada.tipo);
              }

            }

            detalle.set('dirty', false);
            //console.log('VentasBaseController->updateDetalles: dirty: ' + detalle.get('dirty'));
          }
        });
      });
    }
  },

  borrarDetallesEnCambioSucursal: function() {
    //console.log("VentasNewController->borrarDetallesEnCambioSucursal");
    var self = this;
    ////console.log(ruc);
    var detalles = self.get('detalles');

    var detallesArray = [];
    if (detalles) {
      detalles.forEach(function(detalle) {
        detallesArray.push(detalle);
      });
      for (var i = 0; i < detallesArray.length; i++) {
        //console.log(detallesArray[i]);
        self.send('borrarDetalle', detallesArray[i]);
      }
    }

    this.set('detNuevo', this.store.createRecord('ventaDetalle'));
    this.set('productoSeleccionado', null);
    this.set('productoSeleccionadoSW', null);


  }.observes('sucursalSeleccionada'),

  prueba: function() {
    console.log(this.get('loteSeleccionadoModal'));
  }.observes('loteSeleccionadoModal'),


  updateCantidadCuotas: function() {
    //console.log("VentasNewController->updateCantidadCuotas");
    var model = this.get('model');
    var self = this;
    var feedback = this.get('feedback');
    var credito = this.get('credito');
    if (credito) {
      this.set('unicoMedioPago', true);
      this.set('medioPagoSeleccionado', this.get('medioPagoSeleccionadoDefault'));
      this.set('tarjetaSeleccionada', null);
    }
    if (model.get('credito')) {
      //console.log(model.get('cantidadCuotas'));
      self.set('cantidadCuotasTmp', 1);
      var cliente = model.get('cliente');

      if (!cliente || (cliente && (!cliente.get('id') || cliente.get('ruc') == "0"))) {
        feedback.set('clienteRequerido', "Debe seleccionar un cliente si es Venta Crédito");
      }
    } else {
      self.set('cantidadCuotasTmp', 0);
      feedback.set('clienteRequerido', null);
    }
  }.observes('credito'),

  // updateTiposCredito: function() {
  //     var self = this;

  //     if(self.get('credito')) {
  //         self.store.find('tipoCredito', {'by_credito' : true}).then(function(response) {
  //             self.set('tiposCreditos', response);
  //             console.log(response.objectAt(0));
  //             self.set('tipoCreditoDefault', response.objectAt(0));
  //             self.set('tipoCreditoSeleccionado', response.objectAt(0));//el primero es mensual
  //         });
  //     } else {
  //       self.store.find('tipoCredito', {'by_contado' : true}).then(function(response) {
  //             self.set('tiposCreditos', response);
  //             self.set('tipoCreditoDefault', response.objectAt(0));
  //             self.set('tipoCreditoSeleccionado', response.objectAt(0));//viene un solo tipo de credito, contado
  //       });
  //     }
  // }.observes('credito'),
});


Bodega.VentaEditController = Bodega.VentasBaseController.extend({
  formTitle: 'Editar Venta',

  detallesBorrar: [],

  actions: {
    irAPagos: function() {
      var self = this;
      var venta = this.get('model');

      this.transitionToRoute('pagos', venta, { queryParams: { desde: 'ventas' } });
    },
    save: function() {
      var model = this.get('model');
      var self = this;

      ////console.log("Guardando Editarrrr");

      //detalles = this.get('detalles');

      ////console.log(detalles);
      model.set('nombreCliente', this.get('nombreCliente'));
      model.set('total', this.get('totalFinal'));
      model.set('descuento', this.get('descuentoTotal'));
      model.set('iva10', this.get('iva10Total'));
      model.set('iva5', this.get('iva5Total'));
      model.set('ganancia', this.get('calcularGanancia'));
      //model.set('supervisor', this.get('supervisor'));

      //var tipoCredito = this.get('tipoCreditoSeleccionado');
      //model.set('tipoCredito', tipoCredito);

      //var borrarDetalles = this.get('detallesBorrar');
      Bodega.Utils.disableElement('.btn');
      if (model.get('isValid')) {
        model.save().then(function(response) {
          //guardar los detalles

          ////console.log('+++++++++++++++++++++ detalles');
          ////console.log(detalles);
          ////console.log(borrarDetalles);

          ////console.log(detalles);
          var parametros = self.get('parametros');
          // if (!parametros.get('soportaCajaImpresion') && parametros.get('soportaImpresionFacturaVenta')) {
          //   self.imprimirFactura(response);
          // }

          self.transitionToRoute('/ventas?tipo_salida=clientes').then(function() {
            Bodega.Notification.show('Éxito', 'Venta actualizada');
            Bodega.Utils.enableElement('.btn');
          });
        }, function(response) {
          //model.rollback();
          //model.transitionTo('uncommitted');
          Bodega.Notification.show('Error', 'Ha ocurrido un error al guardar la venta', Bodega.Notification.ERROR_MSG);
          Bodega.Utils.enableElement('.btn');
        });
      } else {
        Bodega.Utils.enableElement('.btn');
      }
    },

    saveInterno: function() {
      var model = this.get('model');
      model.set('usoInterno', true);
      this.send('save');
    },

    borrarDetalle: function(detalle) {
      //console.log('Borrar Detalle-----------------------------');
      // var producto = this.store.find('producto', {'id' : detalle.get('producto_id')});
      // producto.then(function(){
      //   console.log("Precio");
      //   console.log(producto.get('precioCompra'));
      //   console.log(producto);
      // });

      if (!this.get('credito')) {
        //detalle.get('producto').unloadRecord();
        //this.get('detallesBorrar').push(detalle);
        //this.get('model').get('ventaDetalles').removeObject(detalle);
        //this.get('detalles').removeRecord(detalle);
        //console.log("hola");
        detalle.deleteRecord();
      }
      console.log(this.get('detalles'));
    }
  }

});



Bodega.VentaDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
      $('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function(response) {
        self.transitionToRoute('/ventas?tipo_salida=clientes');
      });

    },

    cancel: function() {
      $('body').removeClass('modal-open');
      this.transitionToRoute('/ventas?tipo_salida=clientes');
    }
  }
});

Bodega.VentaCuotasIndexController = Ember.ArrayController.extend(Bodega.mixins.Pageable,
  Bodega.mixins.Filterable, {
    staticFilters: {},
    resource: 'ventaCuota'
  });

Bodega.VentaCuotaEditController = Ember.ObjectController.extend({

  imprimirRecibo: function(ventaCuota) {
    //console.log("VentasBaseController->imprimirFactura venta:" + venta);
    var params = {};
    var downloadParams = {};
    downloadParams.httpMethod = 'GET';
    params.content_type = "recibo_cuota";
    params.venta_cuota_id = ventaCuota.get('id');
    downloadParams.data = params;
    Bodega.$.fileDownload("/api/v1/venta_cuotas/", downloadParams);
  },
  formTitle: 'Pago de Cuota de Venta N°',

  numeral: "#",

  actions: {
    save: function() {
      var model = this.get('model');
      var ventaId = this.get('venta_id');
      var self = this;

      model.save().then(function(response) {
        //success
        console.log('llamada a imprimir recibo');
        var parametros = self.get('parametros');
        if (!parametros.get('soportaCajaImpresion') && parametros.get('soportaImpresionRecibo')) {
          self.imprimirRecibo(response);
        }

        self.transitionToRoute('ventaCuotas', ventaId).then(function() {
          Bodega.Notification.show('Éxito', 'Cuota actualizada');
        });
      }, function(response) {
        //error
        //model.rollback();
        Bodega.Notification.show('Error', 'Ha ocurrido un error al guardar la cuota', Bodega.Notification.ERROR_MSG);
      });
    },

    cancel: function() {
      var ventaId = this.get('venta_id');
      this.transitionToRoute('ventaCuotas', ventaId);
    }
  }
});


Bodega.VentasLoginController = Ember.Controller.extend({
  needs: ['ventasNew', 'ventaEdit'],
  actions: {
    checkCredenciales: function(credenciales) {
      var credentials = this.getProperties('identification', 'password');
      this.set('password', null);
      var self = this;
      $.ajax({
        url: '/api/v1/session',
        type: 'POST',
        data: {
          'username': credentials.identification,
          'password': credentials.password,
          'check_only': 1
        },
        accepts: 'application/json',
        success: function(data) {
          if ($.inArray('FE_editar_precio_venta', data.permisos) >= 0) {
            var controllers = [self.get('controllers.ventasNew'), self.get('controllers.ventaEdit')];
            controllers.forEach(function(c) {
              if (c.get('disablePrecio')) {
                c.set('disablePrecio', false);
                c.set('supervisor', credentials.identification);
              }
            });
            self.set('identification', null);
            $('.modal').modal('hide');
            self.send('removeModal');
          } else {
            console.log(data);
            self.set('errorMessage', 'El usuario no cuenta con los permisos!');
          }
        },
        error: function(response) {
          console.log(response);
          self.set('errorMessage', 'Credenciales no válidas');
        }
      });
    },

    clear: function() {
      this.set('errorMessage', null);
      this.set('identification', null);
      this.set('password', null);
      this.set('supervisor', null);
    }
  }
});
