Bodega.ComprasIndexController = Ember.ArrayController.extend(Bodega.mixins.Pageable, Bodega.mixins.Filterable, {
  resource:  'compra',
  hasSearchForm: true,
  searchFormTpl: 'compras/searchform',
  searchFormModal: '#compraSearchForm',
  perPage:  9,

  clearSearchForm: function() {

    this.set('fechaAntes', '');
    this.set('fechaDia', '');
    this.set('fechaDespues', '');
    this.set('nroFactura', '');
    this.set('selectedProveedor', null);
  },

  actions: {
    criteriaSearch: function() {

      var self = this;
      var filters = this.get('filters');
      var fechaAntes = this.get('fechaAntes');
      var fechaDia = this.get('fechaDia');
      var fechaDespues = this.get('fechaDespues');
      var selectedProveedor = this.get('selectedProveedor');
      var nroFactura = this.get('nroFactura');

      if(fechaAntes){
        filters.by_fecha_registro_before = fechaAntes;
      }

      if(fechaDespues){
        filters.by_fecha_registro_after = fechaDespues;
      }

      if(fechaDia){
        // la fecha viene en formato MM/DD/YYYY cambiamos a DD/MM/YYYY
        //fechaDia = moment(fechaDia).format("DD/MM/YYYY");
        filters.by_fecha_registro_on = fechaDia;
      }

      if(selectedProveedor){
        console.log(selectedProveedor);
        filters.by_proveedor_id = selectedProveedor.get('id');
      }

      if(nroFactura) {
        filters.by_nro_factura = nroFactura;
      }

      this.set('filters', filters);
      this.store.find('compra', filters).then(function(model) {
        self.set('model', model);
      });
    }
  }

});

//********************************************************************************************
Bodega.ComprasBaseController = Ember.ObjectController.extend({
  needs: ['application'],

  formTitle: 'Nuevo Ingreso',

  feedback: Ember.Object.create(),

  imgMissing: '/images/missing_small.png',

  controlStockMinimo: Ember.Object.create(),

  tipoCredito: null,

  tiposCreditos: null,

  productoSeleccionado : null,

  numeroHistorial: 3,

  enters: 2,

  detallesBorrar: [],

  promedio_compra: 0,

  detalles:[],

  agregandoDetalle: false,

  CODIGO_TARJETA_CREDITO: 'TC',

  CODIGO_TARJETA_DEBITO: 'TD',

 //Parametrizar esta funcionalidad TODO
  /*calcularPrecioVenta: function(){
    var self = this;
    var producto = this.get('productoSeleccionado');
    var detalle = this.get('detNuevo');

    if(producto){
      if(detalle){
        var margen = producto.get('margen');
        //Filtro de precios
        var parametros = {};
        parametros.by_producto = producto.get('id');
        var precios = this.store.find('precio',parametros);

        //Según el historial de precios.
        precios.then(function(response){
          var prom = 0;

          var count = 1;
          response.forEach(function(precio){
              if(count <= (self.numeroHistorial -1)){
                prom = prom + precio.get('precioCompra');
              }
              count++;
          });

          //En caso de que no tenga historial se promedia con lo que se tenga
          var precioCompraActual = parseFloat(detalle.get('precioCompra'));
          var len = response.get('content').length;
          if(len < (self.numeroHistorial -1)){
            for(var i=len; i<(self.numeroHistorial -1) ; i++){
              prom = prom + precioCompraActual;
            }
          }

          //Se agrega como promedio el precio de compra actual
          prom = prom + precioCompraActual;

          //Se promedia entre el historial considerado
          prom = prom/self.numeroHistorial;


          //Margen de ganancia
          var precioSugerido = (margen/100 * prom) + prom;

          producto.set('precioPromedio',  Math.round(prom));
          //Parametrizar esto
          if(self.get('sugerirPrecio')){
             producto.set('precio', Math.round(precioSugerido));
          }


        });
      }
    }

  }.observes('detNuevo.precioCompra'),*/

    imprimirRetencion: function(compra) {
        console.log("Ejecución de la función imprimriRetención");
        var params = {}
        var downloadParams = {}
        downloadParams.httpMethod = 'GET';
        params.content_type = 'retencion';
        params.compra_id = compra.get('id');

        downloadParams.data = params;
        Bodega.$.fileDownload("/api/v1/compras/", downloadParams);

    },

  loadProveedor: function(){
    var ruc = this.get('ruc');
    var self = this;
    if(ruc){
      var proveedores = this.store.find('proveedor', {'ruc' : ruc});
      proveedores.then(function(){
        var proveedor = proveedores.objectAt(0);
        if(proveedor){
          console.log(proveedor.get('razonSocial'));
          self.set('razonSocial', proveedor.get('razonSocial'));
          self.set('personaContacto', proveedor.get('personaContacto'));
          var model = self.get('model');
          model.set('proveedor', proveedor);
        }
      });
    }
  }.observes('ruc'),


  medioPagoObserver: function() {
    var medioPago = this.get('medioPagoSeleccionado');
    var CODIGO_TARJETA_CREDITO = this.get('CODIGO_TARJETA_CREDITO');
    var CODIGO_TARJETA_DEBITO = this.get('CODIGO_TARJETA_DEBITO');
    var model = this.get('model');

    if(medioPago) {
      model.set('medioPago', medioPago);
      // si el medio de pago es tarjeta de credito, mostrar el combo de tarjetas
      if (medioPago.get('codigo') ===  CODIGO_TARJETA_CREDITO) {
        this.set('esMedioPagoCheque', false);
        var tarjetas = this.get('tarjetasDeCredito');
        if (tarjetas) {
          this.set('esMedioPagoTarjetaCredito', true);
          this.set('tarjetas', tarjetas);
          this.set('tarjetaSeleccionada', tarjetas.objectAt(0));
        }
      } else if  (medioPago.get('codigo') ===  CODIGO_TARJETA_DEBITO ) {
        this.set('esMedioPagoCheque', false);
        var tarjetas = this.get('tarjetasDeDebito');
        if (tarjetas) {
          this.set('esMedioPagoTarjetaCredito', true);
          this.set('tarjetas', tarjetas);
          this.set('tarjetaSeleccionada', tarjetas.objectAt(0));
        }
      } else if (medioPago.get('codigo') === 'CH'){
        this.set('esMedioPagoCheque', true);
        this.set('esMedioPagoTarjetaCredito', false);
      }else {
        this.set('esMedioPagoCheque', false);
        this.set('esMedioPagoTarjetaCredito', false);
        this.set('tarjetaSeleccionada', null);
      }

    }else{
      model.set('medioPago', null);
    }
  }.observes('medioPagoSeleccionado'),

  totalFinal : function() {
    var detalles = this.get('detalles');
    var total = 0;//model.get('total');
    var self = this;

    var model = this.get('model');

    if(this.get('editando')) {
      return model.get('total');
    }
    if (detalles) {
      detalles.forEach(function(detalle){
        total += parseFloat(detalle.get('subtotal'));
      });
    }

    /*var credito = this.get('credito');
    var tipoCredito = this.get('tipoCreditoSeleccionado');

    if (credito && tipoCredito) {
       var interes = tipoCredito.get('interes');
       console.log(interes);
       total = total + (total * interes / 100);
    }*/

    //this.get('model').set('total',total);

    return total;
  }.property('detalles.@each.precio', 'detalles.@each.descuento', 'detalles.@each.cantidad', 'credito', 'tipoCreditoSeleccionado', 'detalles.@each.precioCompra'),

  /*checkSaldoCaja: function(){
    var montoCompra = this.get('model').get('total');

    var caja = this.get('caja');
    var feedback = this.get('feedback');
    if(caja){
      var monto = caja.get('saldo');
      var cajaAbierta = caja.get('abierta')
      if(!cajaAbierta){
        feedback.set('saldo', 'Caja Cerrada');
      }else{
        if(montoCompra > monto){
          feedback.set('saldo', 'El monto de la compra supera su saldo actual: '  + monto);
        }else{
          feedback.set('saldo',null);
        }
      }

    }
  }.observes('total'),*/

  retencionMayorCero : function() {
    console.log("ComprasNewController -> retencionMayorCero");
    var empresaSeleccionada = this.get('empresaSeleccionada');
    var empresaDefault = this.get('empresaDefault');
    var empresa;
    var self = this;

    if(empresaSeleccionada){
        console.log("empresaSeleccionada true");
        empresa = empresaSeleccionada;
    } else{
        console.log("empresaSeleccionada false");
       empresa = empresaDefault;
    }

    console.log("Empresa Seleccionada: ");
    console.log(empresa);

    if(empresa){
      var parametros = this.store.find('parametrosEmpresa', {'by_empresa': empresa.get('id'), 'unpaged': true});
      parametros.then(function() {
        var parametro = parametros.objectAt(0);

        if (parametro) {
            var retencion = parametro.get('retencioniva');
            if(retencion>0)
                self.set("tieneRetencion", true);
            else
                self.set("tieneRetencion", false);
        }
        else {
            return false;
        }
      });
    }
    else {
        return false;
    }
  }.observes('empresaSeleccionada'),

  iva10Total : function() {
    var detalles = this.get('detalles');
    var total = 0;//model.get('total');
    var self = this;

    var model = this.get('model');
    if(this.get('editando') && !this.get('soportaMultimoneda')) {
        return model.get('iva10');
    }
    if (detalles) {
      detalles.forEach(function(detalle){

        var producto = detalle.get('producto');
        if(producto && producto.get('iva') == 10){
          total += (detalle.get('subtotal') / 11);
        }

      });
    }
    iva10 = Math.round((total * 100) / 100);
    //this.get('model').set('iva10',iva10);
    return iva10;
  }.property('detalles.@each.precio', 'detalles.@each.cantidad', 'detalles.@each.precioCompra'),

  iva5Total : function() {
    var detalles = this.get('detalles');
    var total = 0;//model.get('total');
    var self = this;


    var model = this.get('model');

    if(this.get('editando') && !this.get('soportaMultimoneda')) {
      return model.get('iva5');
    }

    if (detalles.length != 0) {
      detalles.forEach(function(detalle){
        var producto = detalle.get('producto');
        if(producto && producto.get('iva') == 5){
          total += (detalle.get('subtotal') / 21);
        }

      });
    }
    iva5 = Math.round((total * 100) / 100);
    //this.get('model').set('iva5',iva5);
    return iva5
  }.property('detalles.@each.precio', 'detalles.@each.cantidad', 'detalles.@each.precioCompra'),

  retencionivaTotalCalculadora : function() {

    var totalRetencion = 0;//model.get('total');
    var self = this;
    var empresaSeleccionada = this.get('empresaSeleccionada');
    var empresaDefault = this.get('empresaDefault');
    var empresa;
    if (!this.get('editando')) {

      if(empresaSeleccionada){
          empresa = empresaSeleccionada;
      } else{
         empresa = empresaDefault;
      }

      if(empresa){
        var parametros = this.store.find('parametrosEmpresa', {'by_empresa': empresa.get('id'), 'unpaged': true});
        parametros.then(function() {
          var parametro = parametros.objectAt(0);

          if (parametro) {
            var retencion = parametro.get('retencioniva');

            if(retencion && retencion > 0){

              var total5 = self.get('iva5Total');
              var total10 = self.get('iva10Total');
              // console.log('IVA 10');
              // console.log(total5)
              // console.log('IVA 5');
              // console.log(total10);

                totalRetencion = Math.round(((total5 + total10) * retencion)/100);
                self.set('retencionivaTotal', totalRetencion);
              }
            }
          });
        }
        self.set('retencionivaTotal', totalRetencion);
      }
  }.observes('detalles.@each.precio', 'detalles.@each.cantidad','empresaSeleccionada', 'detalles.@each.precioCompra'),

  loadProducto: function(){
    if (!this.get('agregandoDetalle')) {
      var codigoBarra = this.get('codigoBarra');
      var self = this;
      var descripcionSW = this.get('descripcionSW');
      var detalle = this.get('detNuevo');
      var codigoLote = this.get('codigoLote');
      var codigoContenedor = this.get('codigoContenedor');
      var fechaVencimiento = this.get('fechaVencimiento');


      if (codigoBarra) {
        var parametros = {};
        parametros.codigo_barra = codigoBarra;
        parametros.by_activo = true;
        var productos = this.store.find('producto', parametros);

        detalle.set('dirty', true);

        productos.then(function() {
          var detalle = self.get('detNuevo');
          if (!self.get('agregandoDetalle') && detalle.get('dirty')) {
            var producto = productos.objectAt(0);
            var model = self.get('model');

            if (producto) {
              self.set('productoSeleccionado', producto);
              self.set('descripcion', producto.get('descripcion'));
              detalle.set('producto', producto);
              var cantidad = 1;
                tipo = producto.get('tipoProducto');
                tipo.then(function(){
                     if (tipo.get('usaLote') && tipo.get('stock')){
                        self.set('muestraLote',true);
                        var lotes = producto.get('lotes');
                        lotes.then(function(response){
                          if (response.content.length > 0) {
                            self.set('existenLotes',true);
                            self.set('lotesDisponibles',response);
                          }else {
                            self.set('existenLotes',false);
                            self.set('loteNuevo',true);
                          }
                        });
                         $("#codigoLote").focus();
                     }
                });



              detalle.set('cantidad', cantidad);


              //TODO cambiar para que sea el ultimo precio de compra

              var precioCompra = producto.get('precioCompra');
              console.log('PRECIO COMPRA EN MONEDA ORIGINAL');
              console.log(precioCompra);
              var precioVenta = producto.get('precio');

              if (self.get('soportaMultimoneda')) {
                var monedaProducto = producto.get('moneda');
                monedaProducto.then(function() {
                  var monedaBase = self.get('monedaBase');
                  var monedaSeleccionada = self.get('monedaSeleccionada');
                  var hash = {};
                  hash['moneda_id'] = monedaSeleccionada.get('id');
                  hash['moneda_base_id'] = monedaProducto.get('id');

                  var cotizacion = self.store.find('cotizacion', {'ultima_cotizacion': hash, 'unpaged': true});

                  cotizacion.then(function() {
                    if(cotizacion.objectAt(0)){
                      console.log("COTIZACION 1");
                      var montoCotizacion = cotizacion.objectAt(0).get('monto');

                      precioCompra = (precioCompra / montoCotizacion).toFixed(2);
                      precioVenta = (precioVenta / montoCotizacion).toFixed(2);

                      console.log("Precio compra actual: " );
                      console.log(precioCompra);
                      detalle.set('precioCompra', precioCompra);
                      console.log("Precio VENTA actual: " );
                      console.log(precioVenta);
                      detalle.set('precioVenta', precioVenta);
                    }
                    else{
                      hash['moneda_id'] = monedaProducto.get('id');
                      hash['moneda_base_id'] = monedaSeleccionada.get('id');
                      //al revés
                      console.log("MONEDA ID");
                      console.log(hash['moneda_id']);
                      console.log("MONEDA BASE ID");
                      console.log(hash['moneda_base_id']);
                      var otraCotizacion = self.store.find('cotizacion', {'ultima_cotizacion': hash, 'unpaged': true});

                      otraCotizacion.then(function() {
                        if(otraCotizacion.objectAt(0)){
                          console.log("COTIZACION 2");
                          var montoCotizacion = otraCotizacion.objectAt(0).get('monto');
                          precioCompra = (precioCompra * montoCotizacion).toFixed(2);
                          precioVenta = (precioVenta * montoCotizacion).toFixed(2);
                          //se multiplica en vez de dividir

                          console.log("Precio compra actual: " );
                          console.log(precioCompra);
                          detalle.set('precioCompra', precioCompra);
                          console.log("Precio VENTA actual: " );
                          console.log(precioVenta);
                          detalle.set('precioVenta', precioVenta);
                        }
                        else{
                          precioCompra = precioCompra.toFixed(2);
                          precioVenta = precioVenta.toFixed(2);

                          console.log("Precio compra actual: " );
                          console.log(precioCompra);
                          detalle.set('precioCompra', precioCompra);
                          console.log("Precio VENTA actual: " );
                          console.log(precioVenta);
                          detalle.set('precioVenta', precioVenta);
                        }
                      });
                    }
                  });
                });
              } else {
                detalle.set('precioCompra', precioCompra);
                detalle.set('precioVenta', precioVenta);
              }

              self.set('descripcionSW', producto._data.descripcion);

            } else {
              self.set('productoSeleccionado', null);
              detalle.set('cantidad', 1);
              detalle.set('precio', 0);
              detalle.set('descuento', 0);
              detalle.set('precioCompra','');
              detalle.set('precioVenta', '');
              self.set('descripcionSW', '');
            }
          }
        });
      }
    }
  },

  observeProveedor: function() {
    var feedback = this.get('feedback');
    var self = this;
    var model = self.get('model');
    var proveedorLabel = this.get('proveedorLabel');
    var proveedorSeleccionado = this.get('proveedorSeleccionado');
    var sponsorSeleccionado = this.get('sponsorSeleccionado');
    if (proveedorSeleccionado) {
      if (proveedorLabel == proveedorSeleccionado.get('infoProveedor') && sponsorSeleccionado== null) {
        model.set('proveedor', proveedorSeleccionado);
      } else if (proveedorLabel == '' || proveedorLabel != proveedorSeleccionado.get('infoProveedor') || sponsorSeleccionado!=null) {
        self.set('proveedorSeleccionado', null);
        model.set('proveedor', null);
        self.set('proveedorLabel', '');
      }
    }
  }.observes('proveedorLabel','sponsorSeleccionado'),

  clearProducto: function () {
      if (!this.get('agregandoDetalle')) {
        this.set('productoSeleccionado', null);
        this.set('descripcionSW', '');
      }
    }.observes('codigoBarra'),

  checkCantidad: function(){
    if (!this.get('agregandoDetalle')) {
      var detalle = this.get('detNuevo');
      var feedback = this.get('feedback');

      var descripcionSW = this.get('descripcionSW');
      $('.tt-input').val(descripcionSW);

      if (detalle) {

        if (detalle !== null) {
          var cantidad = detalle.get('cantidad');
          if (!cantidad) {
              feedback.set('cantidad', "Cantidad debe ser mayor a 0");
          } else {
             feedback.set('cantidad',null);
          }
        }
      }
    }
  }.observes('detNuevo.cantidad'),

  loadCotizacion: function() {
    var monedaSeleccionada = this.get('monedaSeleccionada');
    var monedaAnterior = this.get('monedaAnterior');
    this.set('ultimaMoneda', monedaSeleccionada);
    var self = this;

    var monedaBase = this.get('monedaBase');

    if (monedaSeleccionada && monedaBase) {

        var hash = {};
        hash['moneda_id'] = monedaSeleccionada.get('id');
        hash['moneda_base_id'] = monedaBase.get('id');
        var cotizacion = this.store.find('cotizacion', {'ultima_cotizacion': hash, 'unpaged': true});

        cotizacion.then(function() {
          self.set('montoCotizacion', cotizacion.objectAt(0).get('monto'));
        });
    }
  }.observes('monedaSeleccionada'),



  traducirPrecios: function() {
    var monedaNueva = this.get('monedaSeleccionada');
    var monedaAnterior = this.get('monedaAnterior');
    //esta parte es medio hecha puta pero lo que se hace es mantener la última moneda (en la que se encuentran los detalles)
    //y la nueva, para que se pueda traducir automáticamente los precios de acuerdo a la cotización correspondiente
    this.set('monedaAnterior', monedaNueva);
    var self = this;

    if (monedaNueva && monedaAnterior) {
      var hash = {};
      hash['moneda_id'] = monedaNueva.get('id');
      hash['moneda_base_id'] = monedaAnterior.get('id');
      var cotizacion = this.store.find('cotizacion', {'ultima_cotizacion': hash, 'unpaged': true});

      cotizacion.then(function() {
        if(cotizacion.objectAt(0)){
          montoCotizacion = cotizacion.objectAt(0).get('monto');
          var detalles = self.get('detalles');
          if (detalles){
            detalles.forEach(function(detalle){
              detalle.set('precioCompra', (detalle.get('precioCompra') / montoCotizacion).toFixed(2));
              detalle.set('precioVenta', (detalle.get('precioVenta') / montoCotizacion).toFixed(2));
            });
          }
        }
        else{ //si no hay, buscar al revés y multiplicar en vez de dividir
          hash = {};
          hash['moneda_id'] = monedaAnterior.get('id');
          hash['moneda_base_id'] = monedaNueva.get('id');
          var otraCotizacion = self.store.find('cotizacion', {'ultima_cotizacion': hash, 'unpaged': true});
          otraCotizacion.then(function(){
            if(otraCotizacion.objectAt(0)){
              montoCotizacion = otraCotizacion.objectAt(0).get('monto');
              var detalles = self.get('detalles');
              if (detalles){
                detalles.forEach(function(detalle){
                  detalle.set('precioCompra', (detalle.get('precioCompra') * montoCotizacion).toFixed(2));
                  detalle.set('precioVenta', (detalle.get('precioVenta') * montoCotizacion).toFixed(2));
                });
              }
            }
          });
        }
      });
    }
  }.observes('monedaSeleccionada'),


  loadFromSearchWidget: function () {
    if (!this.get('agregandoDetalle')) {
      var productoSeleccionado = this.get('productoSeleccionadoSW');
     // console.log(productoSeleccionado);
      if (productoSeleccionado && productoSeleccionado.get('id') !== null) {
        var codigoBarraSW = productoSeleccionado.get('codigoBarra');
        this.set('codigoBarra', codigoBarraSW);
        this.loadProducto();
      }
    }
  }.observes('productoSeleccionadoSW'),

  sponsorObserver: function (){
    var donacion = this.get('donacion');
    var campanhaSeleccionada = this.get('campanhaSeleccionada');
    var self = this;

    if(donacion == true && !this.get('id') && campanhaSeleccionada != null){
      var params = {};
      params.by_contacto_campanha = campanhaSeleccionada.get('id');

      this.store.find('sponsor',params).then(function(response){
        console.log(response);
        console.log(response.content.length);
        self.set('sponsors',response);
        self.set('sponsorSeleccionado',response.objectAt(0));
      });
    }else if(donacion == false || campanhaSeleccionada == null){
      self.set('sponsorSeleccionado',null);
    }


  }.observes('donacion','campanhaSeleccionada'),

  actions: {

    agregarDetalle: function() {
      var self = this;
      var producto = this.get('productoSeleccionado');
      var model = this.get('model');
      var detalle = this.get('detNuevo');
      var muestraLote = this.get('muestraLote');
      var loteNuevo = this.get('loteNuevo');
      var codigoContenedor = this.get('codigoContenedor');

      if (producto) {
        if (muestraLote) {
          if (loteNuevo) {
            console.log('holavithe');
            var codigoLote = this.get('codigoLote');
            if (codigoLote == null || codigoLote == '') {
              Bodega.Notification.show('Error', 'Ingrese un codigo de Lote', Bodega.Notification.ERROR_MSG );
              return;
            }
            var lote = self.store.find('lote', {by_codigo: codigoLote});
            lote.then(function(response){
              console.log('lotesssss',response);
            if (response.content.length > 0) {
              Bodega.Notification.show('Error', 'El lote ingresado ya existe', Bodega.Notification.ERROR_MSG );
              return;
            }else {
              detalle.set('codigoLote',codigoLote);
              var fechaVencimiento =  (new Date()).toString();
              detalle.set('fechaVencimiento', fechaVencimiento);
              if(codigoContenedor){
                 detalle.set('codigoContenedor',codigoContenedor);
              }
              self.set('agregandoDetalle', true);
              //crear el nuevo detalle
              detalle.set('producto', producto);
              detalle.set('fechaRegistro', model.get('fechaRegistro'));
              console.log('fechaVencimiento');
              console.log(model.get('fechaVencimiento'));
              detalle.set('fechaVencimiento', detalle.get('fechaVencimiento'));
              self.get('detalles').addRecord(detalle);
              self.set('productoSeleccionado', null);
              self.set('productoSeleccionadoSW', null);
              self.set('codigoBarra', null);
              self.set('disabledFechaVencimiento',false);
              self.set('codigoLote', null);
              self.set('codigoContenedor', null);
              self.set('fechaVencimiento',null);
              self.set('descripcionSW', '');
              self.set('detNuevo', self.store.createRecord('compraDetalle'));
              self.get('controllers.application').set('containerHeight', Bodega.newHeightWrapper(true));
              self.set('lotesDisponibles',null);
              self.set('codigolote',null);
              self.set('loteSeleccionadoModal',null);

              self.clearProducto();

              self.set('agregandoDetalle', false);
              $("#codigoBarra").focus();
              self.set('muestraLote',false);
              self.set('loteNuevo',false);
            }
          });
        }else {
          var loteSeleccionadoModal = this.get('loteSeleccionadoModal');
          if (loteSeleccionadoModal) {
            detalle.set('codigoLote',loteSeleccionadoModal.get('codigoLote'));
          }
          if(codigoContenedor){
             detalle.set('codigoContenedor',codigoContenedor);
          }
          this.set('agregandoDetalle', true);
          //crear el nuevo detalle
          detalle.set('producto', producto);
          detalle.set('fechaRegistro', model.get('fechaRegistro'));
          console.log('fechaVencimiento');
          console.log(model.get('fechaVencimiento'));
          detalle.set('fechaVencimiento', detalle.get('fechaVencimiento'));
          this.get('detalles').addRecord(detalle);
          this.set('productoSeleccionado', null);
          this.set('productoSeleccionadoSW', null);
          this.set('codigoBarra', null);
          this.set('disabledFechaVencimiento',false);
          this.set('codigoLote', null);
          this.set('codigoContenedor', null);
          this.set('fechaVencimiento',null);
          this.set('descripcionSW', '');
          this.set('detNuevo', this.store.createRecord('compraDetalle'));
          this.get('controllers.application').set('containerHeight', Bodega.newHeightWrapper(true));

          this.clearProducto();
          self.set('lotesDisponibles',null);
          self.set('codigolote',null);
          self.set('loteSeleccionadoModal',null);
          this.set('agregandoDetalle', false);
          $("#codigoBarra").focus();
          self.set('muestraLote',false);
          self.set('loteNuevo',false);

        }
      }else {
        this.set('agregandoDetalle', true);
        //crear el nuevo detalle
        detalle.set('producto', producto);
        detalle.set('fechaRegistro', model.get('fechaRegistro'));
        console.log('fechaVencimiento');
        console.log(model.get('fechaVencimiento'));
        detalle.set('fechaVencimiento', detalle.get('fechaVencimiento'));
        this.get('detalles').addRecord(detalle);
        this.set('productoSeleccionado', null);
        this.set('productoSeleccionadoSW', null);
        this.set('codigoBarra', null);
        this.set('disabledFechaVencimiento',false);
        this.set('codigoLote', null);
        this.set('codigoContenedor', null);
        this.set('fechaVencimiento',null);
        this.set('descripcionSW', '');
        this.set('detNuevo', this.store.createRecord('compraDetalle'));
        this.get('controllers.application').set('containerHeight', Bodega.newHeightWrapper(true));

        this.clearProducto();
        self.set('lotesDisponibles',null);
        self.set('codigolote',null);
        self.set('loteSeleccionadoModal',null);

        this.set('agregandoDetalle', false);
        $("#codigoBarra").focus();
        self.set('muestraLote',false);
        self.set('loteNuevo',false);

      }
    }
      this.set('count', 0);
    },

    borrarDetalle: function(detalle) {

      //detalle.get('producto').unloadRecord();
      //this.get('detallesBorrar').push(detalle);
      //this.get('model').get('compraDetalle').removeObject(detalle);
      this.get('detalles').removeRecord(detalle);
      this.get('controllers.application').set('containerHeight', Bodega.newHeightWrapper());

    },


    cancel: function() {
      var model = this.get('model');
      model.deleteRecord();
      this.transitionToRoute('compras');
    },

    save: function() {
      var feedback = this.get('feedback');
      if(!feedback.get('saldo')){
        var model = this.get('model');
        var self = this;
        var tipoCredito = this.get('tipoCreditoSeleccionado');
        var depositoSeleccionado = this.get('depositoSeleccionado');
        var campanhaSeleccionada = this.get('campanhaSeleccionada');
        var proveedorSeleccionado = this.get('proveedorSeleccionado');
        var sponsorSeleccionado = this.get('sponsorSeleccionado');
        var donacion = this.get('donacion');
        var detalles = this.get('detalles');
        var sponsor = this.get('sponsorSeleccionado');
        if (detalles.get('length') == 0){
          Bodega.Notification.show('Atención', 'No agregó detalles, no se puede guardar el ingreso', Bodega.Notification.WARNING_MSG );
          return;
        }

        if(campanhaSeleccionada != undefined){
          model.set('campanha',campanhaSeleccionada);
          if(sponsorSeleccionado != null){
            model.set('sponsor',sponsor);
          }
        }

        //Setear Deposito
        if(depositoSeleccionado){
          model.set('deposito',depositoSeleccionado);
        }else{
          model.set('deposito',this.get('depositoDefault'));
        }
        //Seteamos el tipo de credito
        model.set('tipoCredito', tipoCredito);

        //Seteamos pagado o no pagado
        if(model.get('credito')){
          model.set('pagado',false);
          model.set('deuda', this.get('totalFinal'));
        }else if (this.get('pagado')){
          var medioPagoSeleccionado = this.get('medioPagoSeleccionado');
          model.set('medioPago',medioPagoSeleccionado);

          if(this.get('esMedioPagoTarjetaCredito')){
            model.set('tarjeta',this.get('tarjetaSeleccionada'));

          }else if(medioPagoSeleccionado.get('codigo') == 'CH'){
            var banco = this.get('banco');
            var nroCuenta = this.get('nroCuenta');
            var nroCheque = this.get('nroCheque');
            if(!(banco!= null && nroCheque != null && nroCuenta != null)){
              Bodega.Notification.show('Error', 'Ingrese los datos del cheque', Bodega.Notification.ERROR_MSG );
              return;
            }
            model.set('banco',banco);
            model.set('nroCheque',nroCheque);
            model.set('nroCuenta',nroCuenta);
          }
        }


        //Seteamos totales
        model.set('total',this.get('totalFinal'));
        model.set('iva10',this.get('iva10Total'));
        model.set('iva5',this.get('iva5Total'));
        model.set('retencioniva',this.get('retencionivaTotal'));
        model.set('sucursal', this.get('sucursalSeleccionada'));

        if (self.get('soportaMultimoneda')) {
          model.set('moneda', this.get('monedaSeleccionada'));
        } else {
          model.set('moneda', self.get('monedaBase'));
        }

        console.log(model);
        Bodega.Utils.disableElement('.btn');
         model.save().then(function(response) {
          //self.set('detallesBorrar',[]);
          if(self.get('imprimir')) {
              self.set('detalles',[]);
              var parametros = self.get('parametros');
              if(!parametros || !parametros.get('soportaCajaImpresion') ) {
                 self.imprimirRetencion(response);
              }
          }
          self.transitionToRoute('compras').then(function () {
            Bodega.Notification.show('Éxito', 'Compra registrada');
            Bodega.Utils.enableElement('.btn');
          });

        }, function(response) {
          if(response.errors){
           var faltaStock = response.errors.base;
            if(faltaStock){

              Bodega.Notification.show('Error', faltaStock[0], Bodega.Notification.ERROR_MSG);
              Bodega.Utils.enableElement('.btn');
            }
          }else{
           Bodega.Notification.show('Error', 'Ha ocurrido un error al guardar la compra', Bodega.Notification.ERROR_MSG );
              model.rollback();
              Bodega.Utils.enableElement('.btn');
          }
          Bodega.Utils.enableElement('button[type=submit]');
        });
      }
    },

    saveImprimirRetencion: function() {
        var model = this.get('model');
        model.set('imprimirRetencion', true)
        this.set('imprimir', true);
        this.send('save');
    },

    contarEnters: function() {
      var self = this;
      var count = this.get('count');
      var detalle = this.get('detNuevo');
      var muestraLote = this.get('muestraLote');
      // var habilitarAgregarDetalle = this.get('habilitarAgregarDetalle');
      console.log(muestraLote);
      // console.log(habilitarAgregarDetalle);
      if (count === undefined) {
        count = 0;
        self.set('count', count);
      }

      count = count + 1;

      if (count >= this.get('enters')) {
        this.set('count', 0);
          // if(!muestraLote){
          //   if(detalle && detalle.get('codigoLote')){
          //     detalle.set('codigoLote',null);
          //     self.send('agregarDetalle');
          //   }else{
          //     self.send('agregarDetalle');
          //   }
          // }else if(habilitarAgregarDetalle){
          //   self.send('agregarDetalle');
          // }
              // self.send('cargarLote');
          // }
          self.send('agregarDetalle');

      } else {
        self.set('count', count);
      }
    },

    cargarProducto: function() {
      var self = this;
      var detalle = this.get('detNuevo');
      var codigoLote = this.get('codigoLote');
      var producto = this.get('productoSeleccionado');
      if (producto){
        producto.get('tipoProducto').then(function(response){
          console.log("!response.get('usaLote'): " + !response.get('usaLote'));
          console.log("response.get('stock'): " + response.get('stock'));
          if(!response.get('usaLote') && response.get('stock')){
            if(detalle && detalle.get('codigoLote')){
              detalle.set('codigoLote',null);
              self.send('agregarDetalle');
            }else{
              self.send('agregarDetalle');
            }
          }else{
            self.set('muestraLote',true);
            self.loadProducto();
          }
        });
      } else {
          self.set('muestraLote',false);
          self.loadProducto();
      }
    },

  }
});

//********************************************************************************************
Bodega.CompraEditController = Bodega.ComprasBaseController.extend({
  formTitle: 'Editar Compra',

  actions: {

		irAPagos: function(){
					var self = this;
					var compra = this.get('model');

					this.transitionToRoute('pagos', compra, {queryParams: {desde: 'compras'}});
		},
    save: function() {
      var model = this.get('model');
      var self = this;
      console.log('IMPRIMIR RETENCION');
      console.log(model.get('imprimirRetencion'));

       //Seteamos totales
      model.set('total',this.get('totalFinal'));
      model.set('iva10',this.get('iva10Total'));
      model.set('iva5',this.get('iva5Total'));
      console.log('PARAMETROS: ' + this.get('parametros'));
      Bodega.Utils.disableElement('.btn');
      model.save().then(function(response) {
        //self.set('detallesBorrar',[]);
        self.set('detalles',[]);
       if(self.get('imprimir') ) {
           var parametros = self.get('parametros');
           if(!parametros || !parametros.get('soportaCajaImpresion') ) {
                 self.imprimirRetencion(response);
           }
       }

        self.transitionToRoute('compras').then(function () {
            Bodega.Notification.show('Éxito', 'Compra actualizada');
            Bodega.Utils.enableElement('.btn');
        });

        }, function(response) {
          //error
          Bodega.Notification.show('Error', 'Ha ocurrido un error al actualizar la compra', Bodega.Notification.ERROR_MSG );
          model.rollback();
          Bodega.Utils.enableElement('.btn');
      });

    },

    saveImprimirRetencion: function() {
        var model = this.get('model');
        model.set('imprimirRetencion', true);
        this.set('imprimir', true);
        this.send('save');
    },

  }

});

//********************************************************************************************
Bodega.ComprasNewController = Bodega.ComprasBaseController.extend({

  formTitle: 'Nuevo Ingreso',



  loadSucursal: function() {
        console.log("ComprasNewController -> loadSucursal");
        var empresaSeleccionada = this.get('empresaSeleccionada');
        var self = this;


        if (empresaSeleccionada) {
            var sucursales = this.store.find('sucursal',
                {'unpaged' : true, 'by_activo' : true, 'by_empresa': empresaSeleccionada.get('id')}
            );


            sucursales.then(function(response) {
                self.set('sucursales', response);
                self.set('sucursalSeleccionada',response.objectAt(0));

                /*var sucursal = sucursales.objectAt(0);
                var model = self.get('model');

                if (sucursal) {
                    self.set('sucursalSeleccionada', sucursal);
                    model.set('sucursal', sucursal);

                } else {
                    self.set('sucursalSeleccionada', null);
                    model.set('sucursal', null);
                }*/
            });

            var parametros = this.store.find('parametrosEmpresa', {'by_empresa': empresaSeleccionada.get('id'), 'unpaged': true});
            parametros.then(function() {
              var parametro = parametros.objectAt(0);

              if (parametro) {
                  var moneda = parametro.get('moneda');
                  moneda.then(function(response){
                    self.set('monedaSeleccionada', response);
                  });

                  var monedaBase = parametro.get('monedaBase');
                  monedaBase.then(function(response){
                    self.set('monedaBase', response);
                  });
              }
            });
        }
    }.observes('empresaSeleccionada'),

    creditoObserver: function() {
      credito = this.get('credito');
      if(credito){
        this.set('pagado',false);
      }

    }.observes('credito'),

});
//********************************************************************************************
Bodega.CompraDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
			$('body').removeClass('modal-open');
      var self = this;
      var model = this.get('model');
      model.deleteRecord();
      model.save().then(function(response) {
        self.transitionToRoute('compras');
      }, function(response){
        model.rollback();
        model.transitionTo('uncommitted');
        var faltaStock = response.errors.base;
        if(faltaStock){

          Bodega.Notification.show('Error', faltaStock[0], Bodega.Notification.ERROR_MSG);

        }else{
          Bodega.Notification.show('Error', 'No se pudo borrar la compra.', Bodega.Notification.ERROR_MSG);
        }
        self.transitionToRoute('compras');
      });

    },

    cancel: function() {
			$('body').removeClass('modal-open');
      this.transitionToRoute('compras');
    }
  }
});
/*******************************************************************************************/
Bodega.CompraCuotasIndexController = Ember.ArrayController.extend(Bodega.mixins.Pageable,
  Bodega.mixins.Filterable,{
  staticFilters : {},
  resource:  'compraCuota'
});
/*******************************************************************************************/

Bodega.CompraCuotaEditController = Ember.ObjectController.extend({

  formTitle: 'Pago de Cuota de Compra N°',

  numeral : "#",

  actions: {
    save: function() {
      var model = this.get('model');
      var compraId = this.get('compra_id');
      var self = this;

      model.save().then(function(response) {
        console.log(response);

        self.transitionToRoute('compraCuotas', compraId) ;
      }, function(response) {
        //error
        model.rollback();
      });
    },

    cancel: function() {
      var compraId = this.get('compra_id');
      this.transitionToRoute('compraCuotas', compraId);
    }
  }
});
