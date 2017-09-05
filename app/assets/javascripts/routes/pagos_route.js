Bodega.PagosIndexRoute = Bodega.AuthenticatedRoute.extend({
	
	desde: '', 
  model: function(params) {
		var venta = null;
		var compra = null;
		this.set('desde', params.queryParams.desde);
		
		if(this.desde == 'ventas'){
    	venta = this.modelFor('venta');
			
		}
		if(this.desde == 'compras'){
			compra = this.modelFor('compra');
		}
		
		if(venta){
			var pagos = this.store.find('pago', {
					by_venta: venta.id,
					by_activo: true
			});
		}
		if(compra){
			var pagos = this.store.find('pago', {
					by_compra: compra.id,
					by_activo: true
			});
		}
    return pagos;
 
  },

  renderTemplate: function() {
    this.render('ventas.pagos.index', {
        controller: 'pagosIndex'
    });
  },

  setupController: function(controller, model) {
		var venta = this.modelFor('venta');
		var compra = this.modelFor('compra');
		controller.set('pagoHabilitado', true);
		//se setea en el controller quien hizo el request
		controller.set('desde', this.desde);
		controller.set('desdeVenta', false);
		controller.set('desdeCompra', false);
		if(this.desde == 'ventas'){
			controller.set('modeloPadre', venta);
			controller.set('desdeVenta', true);
			var id = venta.get('id');
			venta.unloadRecord();
			this.store.find('venta', id).then(function(obtenido){
				if(obtenido.get('pagado') == true){
					controller.set('pagoHabilitado', false);
				}
				controller.set('modeloPadre', obtenido);
			});
		}
		if(this.desde == 'compras'){
			controller.set('modeloPadre', compra);
			controller.set('desdeCompra', true);
			var id = compra.get('id');
			compra.unloadRecord();
			this.store.find('compra', id).then(function(obtenido){
				if(obtenido.get('pagado') == true){
					controller.set('pagoHabilitado', false);
				}
				controller.set('modeloPadre', obtenido);
			});
		}
    controller.set('model', model);
    controller.set('currentPage', 1);
    
    model.forEach(function(pago) {
      if ((pago._data.estado != 'Concretado' && pago._data.estado != 'Descuento Rechazado') )
      {
        controller.set('pagoHabilitado', false);
      }

    });
		
		/*if(controller.get('modeloPadre').get('pagado') == true){
			controller.set('pagoHabilitado', false);
		}*/

    //var prestamo = this.modelFor('prestamo');
    //controller.set('prestamo', prestamo);
    //controller.set('nroPrestamo', prestamo.get('id'));
    
    //controller.set('staticFilters', {
      //by_prestamo: prestamo.get('id')
    //});
  }
});

Bodega.PagoRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.PagoEditRoute = Bodega.AuthenticatedRoute.extend({
	
	desde: '', 
	
  model: function(params) {
		this.set('desde', params.queryParams.desde);
    return this.modelFor('pago');
  },

  renderTemplate: function() {
    this.render('ventas.pagos.edit', {
      controller: 'pagoEdit'
    });
  },

  setupController: function(controller, model) {
    controller.set('model', model);

      var parametroMultimoneda = this.store.find('parametrosEmpresa', {'by_soporta_multimoneda': true, 'unpaged' : true});
	  parametroMultimoneda.then(function() {
	    if(parametroMultimoneda.objectAt(0)){
	        controller.set('soportaMultimoneda', true);
	    }
	  });
		
		controller.set('desde', this.desde);
		var venta = this.modelFor('venta');
		var compra = this.modelFor('compra');
		if(this.desde == 'ventas'){
			controller.set('modeloPadre', venta);
		}
		if(this.desde == 'compras'){
			controller.set('modeloPadre', compra);
		}

		//var prestamo = this.modelFor('prestamo');
    var self = this;
    var detalles = model.get('pagoDetalles');

    //model.set('prestamo', prestamo);
    //controller.set('descuentoTotal', model.get('descuentoInteresCompensatorio'));
		controller.set('descuentoTotal', model.get('descuentoMonedaSeleccionada'));

    /*if (model.get('multa')) {
      var multa = model.get('multa');
      var interesNoCobrado = multa / Number(Bodega.Config.porcentajeMulta);
      console.log(interesNoCobrado);

      controller.set('descuentoTotal', Math.round(Number(controller.get('descuentoTotal')) + interesNoCobrado))
    }*/

    var montoInteres = Number(controller.get('descuentoTotal'));
    
    
    

    detalles.then(function(response){
      /*var interesMor = 0;
      var interesPun = 0
      var gastosCob = 0;

      for (i = 0; i < response.content.length; i++) {
        console.log(response.objectAt(i)._data.montoInteresMoratorio);
        interesMor = interesMor + response.objectAt(i)._data.montoInteresMoratorio;
        interesPun = interesPun + response.objectAt(i)._data.montoInteresPunitorio;
        gastosCob = gastosCob + response.objectAt(i)._data.gastosCobranza;
      };
      
      controller.set('detalles', response);      
      controller.set('totalInteresMoratorio', interesMor);
      controller.set('totalInteresPunitorio', interesPun);
      controller.set('totalGastosCobranza', gastosCob);

      var montoInteresFactura = interesMor + interesPun + gastosCob;
      controller.set('totalFacturacion', montoInteresFactura);*/
			controller.set('totalFacturacion', 0);
			controller.set('detalles', response);

      montoInteres = Math.round(montoInteres / 11);
			controller.set('ivaInteres', montoInteres);
      /*var ivaFactura = Math.round(montoInteresFactura / 11);
      controller.set('ivaFactura', ivaFactura);

      var gastosJudiciales = Number(model.get('montoTasaJudicial')) 
                           + Number(model.get('montoNotificaciones')) 
                           + Number(model.get('montoMandamientoEmbargo'));
      controller.set('gastosJudiciales', gastosJudiciales);*/

      var totalAPagar = 0.0;
      totalAPagar = Number(model.get('totalMonedaSeleccionada')) 
      - model.get('descuentoMonedaSeleccionada');
      controller.set('totalAPagar', totalAPagar);
    });

  }
});

Bodega.PagoDeleteRoute = Bodega.AuthenticatedRoute.extend({
	desde: '', 
	
  model: function(params) {
		this.set('desde', params.queryParams.desde);
    return this.modelFor('pago');
  },

  renderTemplate: function() {
    this.render('ventas.pagos.delete', {
      controller: 'pagoDelete'
    });
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    console.log(model);
	controller.set('desde', this.desde);
	var venta = this.modelFor('venta');
	var compra = this.modelFor('compra');
	if(this.desde == 'ventas'){
		controller.set('modeloPadre', venta);
		model.set('venta', venta);
	}
	if(this.desde == 'compras'){
		controller.set('modeloPadre', compra);
		model.set('compra', compra)
	}
  }
});

Bodega.PagosNewRoute = Bodega.AuthenticatedRoute.extend({
	
	desde: '', 

  model: function(params) {

    //var parametros = params['queryParams'];

    //this.set('aReestructurar', parametros['aReestructurar']);
    //this.set('aCancelar', parametros['cancelar']);
    //this.set('aImpugnar', parametros['impugnar']);
		
		this.set('desde', params.queryParams.desde);

    var pago = this.store.createRecord('pago');
    return pago;
  },

  renderTemplate: function() {
    this.render('ventas.pagos.new', {
      controller: 'pagosNew'
    });
  },

  setupController: function(controller, model) {
    controller.set('model', model);

	  var parametroMultimoneda = this.store.find('parametrosEmpresa', {'by_soporta_multimoneda': true, 'unpaged' : true});
	  parametroMultimoneda.then(function() {
	    if(parametroMultimoneda.objectAt(0)){
	        controller.set('soportaMultimoneda', true);
	    }
	  });
		
		controller.set('desde', this.desde);
		var venta = this.modelFor('venta');
		var compra = this.modelFor('compra');
		if(this.desde == 'ventas'){
			controller.set('modeloPadre', venta);
			model.set('venta', venta);
		}
		if(this.desde == 'compras'){
			controller.set('modeloPadre', compra);
			model.set('compra', compra)
		}
		
    var self = this;
    var detalles = model.get('pagoDetalles');

    var aReestructurar = this.get('aReestructurar');
    controller.set('aReestructurar', aReestructurar);

    /*var aCancelar = this.get('aCancelar');
    controller.set('aCancelar', aCancelar);
    var aImpugnar = this.get('aImpugnar');
    controller.set('aImpugnar', aImpugnar);*/

    /*if (aReestructurar || aCancelar)
      controller.set('bloqueo', true);
    else
      controller.set('bloqueo', false);*/
		//Como nunca se puede reestructurar ni cancelar, se pone bloqueo a false
		controller.set('bloqueo', false);

    /*controller.set('formTitle', (this.get('aReestructurar') ? 'Reestructuracion' : 'Nuevo Pago'));
    controller.set('totalTitle', (this.get('aReestructurar') ? 'Monto de reestructuración' : 'Total a pagar'));
    controller.set('formTitle', (this.get('aImpugnar') ? 'Impugnar Préstamo' : 'Nuevo Pago'));
    controller.set('totalTitle', (this.get('aImpugnar') ? 'Monto de Jucio' : 'Total a pagar'));*/
		controller.set('formTitle', 'Nuevo Pago');
		controller.set('totalTitle', 'Total a pagar');

    detalles.then(function(response){
      controller.set('detalles', response);
    });
		

		if(this.desde == 'compras'){
			this.store.find('compra_cuota', {by_compra: compra.id, pendientes: true, unpaged: true}).then(function(response) {
					controller.set('cuotasPendientes', response);
					var cantCuotas = new Array(response.content.length);
					var i = 0;
					for (i = 0; i < cantCuotas.length; i++) {
						cantCuotas[i] = i + 1;  
					};
					controller.set('cantidadCuotas', cantCuotas);
					controller.set('cantidadCuotasSeleccionadas', cantCuotas[0]);
			});
		}
		if(this.desde == 'ventas'){
			this.store.find('venta_cuota', {by_venta: venta.id, pendientes: true, unpaged: true}).then(function(response) {
					controller.set('cuotasPendientes', response);
					var cantCuotas = new Array(response.content.length);
					var i = 0;
					for (i = 0; i < cantCuotas.length; i++) {
						cantCuotas[i] = i + 1;  
					};
					controller.set('cantidadCuotas', cantCuotas);
					controller.set('cantidadCuotasSeleccionadas', cantCuotas[0]);
			});
		}
		
		model.set('montoCotizacion', 1);
		controller.set('monedaSeleccionada', controller.get('modeloPadre').get('data.moneda'));
		controller.set('monedaPadre', controller.get('modeloPadre').get('data.moneda'));
		this.store.find('moneda').then(function(response){ 
          controller.set('monedas', response);
					
        });
		

    controller.set('totalAPagar', 0);
    controller.set('montoUltimaCuota', 0);
    //controller.set('prestamo_id', prestamo.get('id'));
    //controller.set('nroPrestamo', prestamo.get('id'));
  }
});