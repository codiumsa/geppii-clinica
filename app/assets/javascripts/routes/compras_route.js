/*global Bodega, console, moment */
Bodega.CompraRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.ComprasIndexRoute = Bodega.AuthenticatedRoute.extend({

  model: function() {
    return this.store.find('compra', {page: 1});
                       //    by_fecha_registro_on: Bodega.Utils.getCurrentDate()});
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);

    //Deshabilita control de caja
    controller.set('cajaCerrada',null);
    /*var cajas = this.store.find('caja', {obtenerCajaChica:true});
    cajas.then(function(response){
      var caja = cajas.objectAt(0);
      caja.reload();

      if(!caja.get('abierta')){
        controller.set('cajaCerrada',true);

      }else{
        controller.set('cajaCerrada',null);
      }
    });*/
    proveedorParams = {};
    proveedorParams.by_activo = true;
    proveedorParams.unpaged = true;

    this.store.find('proveedor', proveedorParams).then(function(response){
      controller.set('proveedores', response);
    });

    // filtro por defecto
    //controller.set('fechaDia', Bodega.Utils.getCurrentDate('MM/DD/YYYY'));

    var parametroMultimoneda = this.store.find('parametrosEmpresa', {'by_soporta_multimoneda': true, 'unpaged' : true});
    parametroMultimoneda.then(function() {
      if(parametroMultimoneda.objectAt(0)){
          controller.set('soportaMultimoneda', true);
      }
      else{
        controller.set('soportaMultimoneda', false);
      }
    });
  }
});

Bodega.CompraEditRoute = Bodega.RequiereCajaAbiertaRoute.extend({
  model: function(params) {
    return this.modelFor('compra');
  },

  renderTemplate: function() {
    this.render('compras.new', {
      controller: 'compraEdit'
    });
  },

  setupController: function(controller, model) {
      controller.set('model', model);
      var self = this;
      var detalles = model.get('compraDetalles');
      var proveedor =  model.get('proveedor');
      controller.set('edicionCompra', true);
      controller.set('editando', true);

      //Deshabilita control de caja
      controller.set('cajaCerrada',null);
     /* var cajas = this.store.find('caja', {obtenerCajaChica:true});
      cajas.then(function(response){
        var caja = cajas.objectAt(0);
        controller.set('caja',caja);

        if(! caja.get('abierta') ){

          controller.set('cajaCerrada',true);

        }
      });*/

      this.store.find('moneda', {'by_activo' : true}).then(function(response){
        controller.set('monedas', response);
      });

      model.get('moneda').then(function(response){
          if (response) {
            controller.set('monedaSeleccionada', response);
          }
      });


      var parametroMultimoneda = this.store.find('parametrosEmpresa', {'by_soporta_multimoneda': true, 'unpaged' : true});
      parametroMultimoneda.then(function() {
        if(parametroMultimoneda.objectAt(0)){
            controller.set('soportaMultimoneda', true);
        }
      });

      if(proveedor){
        proveedor.then(function function_name (argument) {
          controller.set('razonSocial', proveedor.get('razonSocial'));
          controller.set('ruc', proveedor.get('ruc'));
        });
      }

      detalles.then(function(response){
        controller.set('detalles', response);
      });

      if(model.get('credito')) {
        model.get('tipoCredito').then(function(response){
            if (response) {
              controller.set('tipoCreditoSeleccionado', response);
            }
        });

        if(model.get('credito')){
          controller.set('puedeEditar', false);
        }else{
          controller.set('puedeEditar', true);
        }
      }

      /*
      var sucursal = model.get('sucursal');

      sucursal.then(function(su) {

        var empresa = su.get('empresa');
        controller.set('empresaDefault', empresa);
        controller.set('sucursalSeleccionada',su);
        controller.set('empresaSeleccionada', empresa);


      //controller.set('detNuevo', this.store.createRecord('compraDetalle'));
      */

//      var sucursal = model.get('sucursal');
//
//      sucursal.then(function(su) {
//        var empresa = su.get('empresa');
//        empresa.then(function() {
//            var parametros = self.store.find('parametrosEmpresa', {'by_empresa': empresa.get('id'), 'unpaged': true});
//            parametros.then(function() {
//                var parametro = parametros.objectAt(0);
//
//                if (parametro) {
//                    var retencion = parametro.get('retencioniva');
//                    if(retencion>0)
//                        self.controller.set("tieneRetencion", true);
//                    else
//                        self.controller.set("tieneRetencion", false);
//                }
//            });
//        });
//      });
//
      var parametros = this.store.find('parametrosEmpresa',
                    {'by_soporta_caja_impresion': true, 'unpaged': true}
                );

                parametros.then(function(){
                    var parametro = parametros.objectAt(0);
                  controller.set('parametros', parametros.objectAt(0));
                });



      controller.set('editar', true);
      controller.get('feedback').set('saldo',null);
      controller.set('sugerirPrecio', this.hasPermission('FE_modificar_precio'));
    }


});

Bodega.CompraDeleteRoute = Bodega.RequiereCajaAbiertaRoute.extend({
  model: function(params) {
    return this.modelFor('compra');
  },

  renderTemplate: function() {
    this.render('compras.delete', {
      controller: 'compraDelete'
    });
  }
});

Bodega.ComprasNewRoute = Bodega.RequiereCajaAbiertaRoute.extend({
  model: function() {
    return this.store.createRecord('compra');
  },

  setupController: function(controller, model) {
      controller.set('model', model);
      var self = this;
      var detalles = model.get('compraDetalles');
      controller.set('cantidadCuotas', 1);
      controller.set('editando', false);
      controller.set('muestraLote',false);
      controller.set('habilitarAgregarDetalle',false);
      controller.set('loteNuevo',false);

      //var cajas = this.store.find('caja', {obtenerCajaChica:true});

      //Deshabilita control de caja
      controller.set('cajaCerrada',null);
     /* cajas.then(function(response){
        var caja = cajas.objectAt(0);
        controller.set('caja',caja);

        if(! caja.get('abierta') ){

          controller.set('cajaCerrada',true);

        }
      });*/
      controller.set('esMedioPagoCheque',false);

      this.store.find('campanha').then(function(response){
        controller.set('campanhas', response);
        controller.set('campanhaSeleccionada', response.objectAt(0));
      });

      this.store.find('medioPago').then(function(response){
        controller.set('mediosPagos', response);
        console.log(response);
        controller.set('medioPagoSeleccionado', response.objectAt(0));
      });

      this.store.find('tarjeta', {unpaged: true, by_codigo_medio_pago: 'TC', by_activo: true}).then(function(response){
          if (response.content) {
            controller.set('tarjetasDeCredito', response.content);
          }
      });

      this.store.find('tarjeta', {unpaged: true, by_codigo_medio_pago: 'TD', by_activo: true}).then(function(response){
          if (response.content) {
              controller.set('tarjetasDeDebito', response.content);
          }
      });

      controller.set('habilitaFechaVencimiento',true);
      // model.set('fechaVencimiento', new Date());

      this.store.find('moneda', {'by_activo' : true}).then(function(response){
        controller.set('monedas', response);
      });

      var parametroMultimoneda = this.store.find('parametrosEmpresa', {'by_soporta_multimoneda': true, 'unpaged' : true});
      parametroMultimoneda.then(function() {
        if(parametroMultimoneda.objectAt(0)){
            controller.set('soportaMultimoneda', true);
        }
      });

    tipoCreditoParams = {};
    tipoCreditoParams.by_activo = true;
    tipoCreditoParams.unpaged = true;

     this.store.find('tipoCredito', tipoCreditoParams).then(function(response){
        controller.set('tiposCreditos', response);
        controller.set('tipoCreditoDefault', response.objectAt(0));
      });

    depositoParams = {};
    depositoParams.by_activo = true;
    depositoParams.unpaged = true;
     this.store.find('deposito', depositoParams).then(function(response){
        controller.set('depositos', response);
         depositogabino = null;
         _.forEach(response.content, function(temp) {
            if(temp._data.nombre == 'Punto de Venta Casa Nancy'){
                 depositogabino = temp;
            }
        });
         if(depositogabino){
             controller.set('depositoDefault',depositogabino);
             controller.set('depositoSeleccionado', depositogabino);
         }else{
             controller.set('depositoDefault',response.objectAt(0));
             controller.set('depositoSeleccionado', response.objectAt(0));
         }

      });

     detalles.then(function(response){
        controller.set('detalles', response);
      });

     //Seteo de parametros del sistema para la vista
      this.store.find('empresa').then(function(response) {
            controller.set('empresas', response);
            var empresaDefault = response.objectAt(0);

            if (empresaDefault) {
                var parametros = self.store.find('parametrosEmpresa',
                    {'by_empresa': empresaDefault.get('id'), 'unpaged': true}
                );

                parametros.then(function(){
                  console.log("PArametros: " + parametros);
                  var param = parametros.objectAt(0);
                  controller.set('parametros', param);
                    console.log(param);
                  var retencion = param.get('retencioniva');
                  if(retencion>0)
                    self.controller.set("tieneRetencion", true);
                  else
                    self.controller.set("tieneRetencion", false);

                  var moneda = param.get('moneda');
                  moneda.then(function(response){
                    self.controller.set('monedaSeleccionada', response);
                    var monedaBase = param.get('monedaBase');
                    monedaBase.then(function(response){

                      self.controller.set('monedaBase', response);
                      var hash = {};
                      hash['moneda_id'] = moneda.get('id');
                      hash['moneda_base_id'] = monedaBase.get('id');
                      var cotizacion = self.store.find('cotizacion', {'ultima_cotizacion': hash, 'unpaged': true});

                      cotizacion.then(function() {
                        self.controller.set('cotizacion', cotizacion.objectAt(0));
                        self.controller.set('montoCotizacion', cotizacion.objectAt(0).get('monto'));
                      });
                    });
                  });
                });

                var sucursales = self.store.find('sucursal',
                    {'unpaged' : true, 'by_activo' : true, 'by_empresa': empresaDefault.get('id')}
                );

                sucursales.then(function() {
                    var sucursal = sucursales.objectAt(0);

                    if (sucursal) {
                        controller.set('sucursalSeleccionada', sucursal);
                        model.set('sucursal', sucursal);
                    } else {
                        controller.set('sucursalSeleccionada', null);
                        model.set('sucursal', null);
                    }
                    console.log("Sucursales:");
                    console.log(sucursales);
                    controller.set('sucursales', sucursales);
                });


            }


        });


      controller.set('detNuevo', this.store.createRecord('compraDetalle'));
      controller.set('ruc', '0');
      controller.set('puedeEditar', true);
      controller.get('feedback').set('saldo',null);
      controller.set('edicionCompra', false);
      controller.set('descripcionSW', null);
      controller.set('productoSeleccionadoSW', null);
      controller.set('sugerirPrecio', this.hasPermission('FE_modificar_precio'));
    }
});

Bodega.CompraCuotasIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    var compra = this.modelFor('compra');


    var cuotas =  this.store.find('compraCuota', {by_compra: compra.id});

    return cuotas;
  },

  renderTemplate: function() {
    this.render('compras.cuotas.index', {
      controller: 'compraCuotasIndex'
    });
  },

  setupController: function(controller, model) {
    controller.set('model', model);

    var compra = this.modelFor('compra');
    controller.set('nroFactura', compra.get('nroFactura'));
    controller.set('staticFilters', {by_compra: compra.get('id')});
    //controller.set('currentPage', 1);

  }

});


Bodega.CompraCuotaEditRoute = Bodega.RequiereCajaAbiertaRoute.extend({
  model: function(params) {
    return this.modelFor('compraCuota');
  },

  renderTemplate: function() {
    this.render('compras.cuotas.edit', {
      controller: 'compraCuotaEdit'
    });

  },

  setupController: function(controller, model) {
    controller.set('model', model);
    var fechaCobro = model.get('fechaCobro');
    if (!fechaCobro) {
      fechaCobro = moment().toDate();
      model.set('fechaCobro', fechaCobro);
    }
    var compra = this.modelFor('compra');
    controller.set('compra_id', compra.get('id'));
  }
});
