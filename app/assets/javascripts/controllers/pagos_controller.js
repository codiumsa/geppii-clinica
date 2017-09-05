Bodega.PagosIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable, 
  Bodega.mixins.Filterable, {
  resource:  'pago',
  perPage:  15,
  actions:{
    irACompra: function(){
      var self = this;
      var compra = this.get('modeloPadre');
      compra = this.store.getById('compra', compra.get('id'));
      
      this.transitionToRoute('compra.edit', compra);
    },
		irAVenta: function(){
      var self = this;
      var venta = this.get('modeloPadre');
      venta = this.store.getById('venta', venta.get('id'));
      
      this.transitionToRoute('venta.edit', venta);
    },
		
		irANuevo: function(){

      this.transitionToRoute('pagos.new', {queryParams: {desde: this.get('desde')}});
    }, 
		irAEditar: function(item){

      this.transitionToRoute('pago.edit', item, {queryParams: {desde: this.get('desde')}});
    }, 
		irAEliminar: function(item){
      console.log("item....");
      console.log(item);
      this.transitionToRoute('pago.delete', item, {queryParams: {desde: this.get('desde')}});
    }
  }

});

Bodega.PagoBaseController = Ember.ObjectController.extend({

  formTitle: 'Editar Pago',

  totalTitle: 'Total',

  numeral: '#'

});

Bodega.PagosNewController = Bodega.PagoBaseController.extend({

// Controla el combo de la cantidad de cuotas, y llama al método "CargaTotal".
  controlaCombo: function() {
    this.send('cargaTotal');
  }.observes('cantidadCuotasSeleccionadas'),
	
	controlarMonedaSeleccionada: function() {
		this.get('model').set('descuento', 0);
		this.get('model').set('descuentoMonedaSeleccionada', 0);
		this.get('model').set('moneda', this.get('monedaSeleccionada'));
		var monedaBase = this.get('monedaSeleccionada');
		var moneda = this.get('monedaPadre');
		var self = this;

		if(!monedaBase || !moneda) {
			return;
		}
		var params = {
			moneda_id: moneda.get('id'),
			moneda_base_id: monedaBase.get('id')
		};
		var cotizaciones = self.store.find('cotizacion', {ultima_cotizacion: params});
		cotizaciones.then(function() {
			var cotizacion = cotizaciones.objectAt(0);
			if(cotizacion) {
				self.get('model').set('montoCotizacion', cotizacion.get('monto'));
				self.send('cargaTotal');
			}else{
					// buscamos el otro sentido de la cotización
					params = {
						moneda_id: monedaBase.get('id'),
						moneda_base_id: moneda.get('id')
					};
					cotizaciones = self.store.find('cotizacion', {ultima_cotizacion: params});
					cotizaciones.then(function() {
						cotizacion = cotizaciones.objectAt(0);
						self.get('model').set('montoCotizacion', cotizacion.get('monto'));
						self.send('cargaTotal');
					});
			}
		});
    
  }.observes('monedaSeleccionada'),

  recotizar: function() {
    var monedaBase = this.get('monedaSeleccionada');
    var moneda = this.get('monedaPadre');
    var self = this;

    if(!monedaBase || !moneda) {
      return;
    }
    var params = {
      moneda_id: moneda.get('id'),
      moneda_base_id: monedaBase.get('id')
    };
    var cotizaciones = self.store.find('cotizacion', {ultima_cotizacion: params});
    cotizaciones.then(function() {
      var cotizacion = cotizaciones.objectAt(0);
      if(cotizacion) {
        //callback(cotizacion, true);
        var cambiado = self.get('model').get('totalMonedaSeleccionada')/self.get('model').get('montoCotizacion');
        self.get('model').set('total', cambiado);
        cambiado = self.get('model').get('descuentoMonedaSeleccionada')/self.get('model').get('montoCotizacion');
        self.get('model').set('descuento', cambiado);
        self.send('controlarTotal');
      }else{
        // buscamos el otro sentido de la cotización
        params = {
          moneda_id: monedaBase.get('id'),
          moneda_base_id: moneda.get('id')
        };
        cotizaciones = self.store.find('cotizacion', {ultima_cotizacion: params});
        cotizaciones.then(function() {
          cotizacion = cotizaciones.objectAt(0);
          //callback(cotizacion, false);
          var cambiado = self.get('model').get('totalMonedaSeleccionada')*self.get('model').get('montoCotizacion');
          self.get('model').set('total', cambiado);
          cambiado = self.get('model').get('descuentoMonedaSeleccionada')*self.get('model').get('montoCotizacion');
          self.get('model').set('descuento', cambiado);
          self.send('controlarTotal');
        });
      }
        
    });
  }.observes('totalMonedaSeleccionada','descuentoMonedaSeleccionada'),

  actions: {
// Controla la fecha, cada vez que la misma cambia se obtiene nuevamente el listado de cuotas pendientes
// con los nuevos intereses y gastos calculados a esa fecha.
// Se pasa como parámetro la fecha seleccionada, y al obtener las cuotas se llama al metodo "cargaTotal".
    controlaFecha: function() {
      var model = this.get('model');
      var self = this;
      var params = {};
      var date = moment(model.get('fechaPago'));
      var modeloId = this.get('modeloPadre').get('id');
      if (date && modeloId) {
        params.fecha_pago = date.format('DD-MM-YYYY');
				if(this.get('desde') == 'compras'){
        	params.by_compra = modeloId;
				}else{
					params.by_venta = modeloId
				}
        params.pendientes = true;
        params.unpaged = true;
        this.set('params', params);

        this.store.find('cuota', params).then(function(response) {
            self.set('cuotasPendientes', response);
            self.send('cargaTotal');
        });
      }
    },

// Setea todos los valores del pago, teniendo en cuenta la fecha seleccionada y la cantidad de cuotas a pagar.
// Setea los descuentos máximos y la multa en caso de que el pago sea una cancelación de préstamo.
// Llama al método "controlarTotal".
    cargaTotal: function() {
      var model = this.get('model');
      var cuotasPendientes = this.get('cuotasPendientes');
      var cantCuotas = this.get('cantidadCuotasSeleccionadas');
      var montoCuota = 0;

      if(cuotasPendientes && cantCuotas) {
        for (var i = 0; i < cantCuotas; i++) {
          this.set('montoUltimaCuota', montoCuota);
					
					var capital = cuotasPendientes.objectAt(i)._data.pendiente;
					montoCuota += capital;
					
         }

        model.set('total', montoCuota);
				this.set('descuentoMaximo', montoCuota);
       
				
				var monedaBase = this.get('monedaSeleccionada');
				var moneda = this.get('monedaPadre');
				var self = this;

				if(!monedaBase || !moneda) {
					return;
				}
				var params = {
					moneda_id: moneda.get('id'),
					moneda_base_id: monedaBase.get('id')
				};
				var cotizaciones = self.store.find('cotizacion', {ultima_cotizacion: params});
				cotizaciones.then(function() {
					var cotizacion = cotizaciones.objectAt(0);
					if(cotizacion) {
						//callback(cotizacion, true);
						var cambiado = self.get('model').get('total')*self.get('model').get('montoCotizacion');
						self.get('model').set('totalMonedaSeleccionada', cambiado);
						self.send('controlarTotal');
					}else{
						// buscamos el otro sentido de la cotización
						params = {
							moneda_id: monedaBase.get('id'),
							moneda_base_id: moneda.get('id')
						};
						cotizaciones = self.store.find('cotizacion', {ultima_cotizacion: params});
						cotizaciones.then(function() {
							cotizacion = cotizaciones.objectAt(0);
							//callback(cotizacion, false);
							var cambiado = self.get('model').get('total')/self.get('model').get('montoCotizacion');
							self.get('model').set('totalMonedaSeleccionada', cambiado);
							self.send('controlarTotal');
						});
					}

				});

        //this.send('controlarTotal');
      }

    },
		
	//Esto sirve para garantizar que el total siempre se encuentra en la moneda indicada por la compra/venta	


// Controla que los valores introducidos en el campo Total estén en el rango entre el total de la (i - 1) cuota
// y el total de la cuota (i), siendo (i) la cantidad de cuotas seleccionadas, y llama al método "controlarDescuento"
    controlarTotal: function() {
      var model = this.get('model');
      var cantCuotas = this.get('cantidadCuotasSeleccionadas');
      cantCuotas -= 1;
      var cuotasPendientes = this.get('cuotasPendientes');
      var capital = cuotasPendientes.objectAt(cantCuotas)._data.pendiente;
      
			var totalUltimaCuota = capital;

      if (this.get('total')) {
        if (this.get('total') <= this.get('montoUltimaCuota')) {
          model.set('total', this.get('montoUltimaCuota'));
        } else if (this.get('total') > this.get('montoUltimaCuota') + totalUltimaCuota) {
          model.set('total', this.get('montoUltimaCuota') + totalUltimaCuota);
        }
      } else {
        model.set('total', 0);
      }
      console.log('Total: ' + model.get('total'));
      this.send('controlarDescuento');
    },

// Controla que los descuentos ingresados estén entre 0 y el monto de descuento máximo para cada tipo de descuento, 
// calcula y setea el total a pagar teniendo en cuenta el total, los descuentos y la multa.
    controlarDescuento: function() {
      console.log("Controlando descuentos");
      var model = this.get('model');
			
			if (!model.get('descuento'))
        model.set('descuento', 0);
      else if (model.get('descuento') > this.get('descuentoMaximo')) {
        model.set('descuento', this.get('descuentoMaximo'));
      }

      
      var totalAPagar = 0.0;
      totalAPagar = Number(model.get('totalMonedaSeleccionada')) 
      - model.get('descuentoMonedaSeleccionada') 
      console.log('TotalAPagar: ' + totalAPagar);
      this.set('totalAPagar', totalAPagar);
    },

    save: function() {
      var model = this.get('model');
      var self = this;
      var prestamoId = this.get('prestamo_id');
      var detalles = model.get('detalles');
      var cuotasPendientes = this.get('cuotasPendientes');
      var cantCuotas = this.get('cantidadCuotasSeleccionadas');

      for (var i = 0; i < cantCuotas; i++) {
        var cuota = cuotasPendientes.objectAt(i);
        var detalle = this.store.createRecord('pagoDetalle');
				if(this.get('desde') == 'compras'){
        	detalle.set('compraCuota', cuota);
				}
				if(this.get('desde') == 'ventas'){
        	detalle.set('ventaCuota', cuota);
				}
        detalles.addRecord(detalle);
      }
      if (!model.get('fechaPago'))
        model.set('fechaPago', moment().toDate())
      if (!model.get('total'))
        model.set('total', 0);
      if (!model.get('descuento'))
        model.set('descuento', 0); 
            
      Bodega.Utils.disableElement('button[type=submit]');

      if(model.get('isValid')) {
         model.save().then(function(response) {
          //store.unloadRecord(model.get('prestamo'));
          //success
          //if (self.get('aReestructurar')) {
            /*self.transitionToRoute('solicitudes.new', {
              queryParams: { pago_id: response.id
            }});
          } else {*/
            self.transitionToRoute('pagos', self.get('modeloPadre'), {queryParams: {desde: self.get('desde')}}).then(function() {
              Bodega.Notification.show('Éxito', 'Pago Guardado');
            });
          //}
          Bodega.Utils.enableElement('button[type=submit]');
        }, function(response) {
          //error
          if(response.responseJSON){
            Bodega.Notification.show('Error', 'Ha ocurrido un error al guardar el pago. ' + response.responseJSON.message, Bodega.Notification.ERROR_MSG );
            Bodega.Utils.enableElement('button[type=submit]');
          }

          if(response.errors){
            var errores = response.errors.base;
            if(errores){
              for(var i=0; i<errores.length; i++){
                Bodega.Notification.show('Error', errores[i], Bodega.Notification.ERROR_MSG);
              }
            }
          }
        });
      }else{
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },

    cancel: function() {
			if(this.get('desde') == 'compras'){
				var modeloPadre = this.get('modeloPadre');
				//this.transitionToRoute('compra.edit', modeloPadre);
				this.transitionToRoute('pagos', this.get('modeloPadre'), {queryParams: {desde: this.get('desde')}})
			}
			if(this.get('desde') == 'ventas'){
				var modeloPadre = this.get('modeloPadre');
				//this.transitionToRoute('venta.edit', modeloPadre);
				this.transitionToRoute('pagos', this.get('modeloPadre'), {queryParams: {desde: this.get('desde')}})
			}
    }
  }
});

Bodega.PagoEditController = Bodega.PagoBaseController.extend({

  formTitle: 'Editar Pago',

  controlarDescuento: function() {
    var model = this.get('model');
    //var detalles model.get('pagoDetalles');
    var montoIntereses = 0;

    //console.log(detalles);

    // for (var i = 0; i < detalles.lenght; i++) {
    //   var interes = cuotasPendientes.objectAt(i)._data.montoInteresPendiente;
    //   var interesMoratorio = cuotasPendientes.objectAt(i)._data.montoInteresMoratorio;
    //   var interesPunitorio = cuotasPendientes.objectAt(i)._data.montoInteresPunitorio;
    //   var gastosCobranza = cuotasPendientes.objectAt(i)._data.gastosCobranza;
    //   montoIntereses = interes + interesPunitorio + interesMoratorio + gastosCobranza;
    // }

    // if (!this.get('descuento'))
    //   this.set('descuento', 0);
    // else if (this.get('descuento') > this.get('descuentoMaximo')) {
    //   this.set('descuento', this.get('descuentoMaximo'));
    // }
  }.observes('descuento'),

  /*imprimirRecibo: function(id) {
    var model = this.get('model');
    var params = {}
    var downloadParams = {}
    downloadParams.httpMethod = 'GET';
    params.content_type = "pdf";
    params.report_type = "recibo";
    params.pago_id = model.get('id');
     
    downloadParams.data = params;
    console.log('ANTES DE LA DESCARGA DEL DOCUMENTO');
    Bodega.$.fileDownload("/api/v1/pagos", downloadParams);
    console.log('DESPUES DE LA DESCARGA DEL DOCUMENTO');
  },*/

  actions: {

    print: function() {
      var model = this.get('model');
      var params = {}
      var downloadParams = {}
      downloadParams.httpMethod = 'GET';
      params.content_type = "pdf";
      params.report_type = "recibo";
      params.pago_id = model.get('id');
       
      downloadParams.data = params;
      //Bodega.$.fileDownload("/api/v1/pagos", downloadParams);
      Bodega.Utils.printPdf('/api/v1/pagos/', params);
    },

    

    save: function() {
      var model = this.get('model');
      var self = this;
      model.set('estado', 'Concretado');

      Bodega.Utils.disableElement('button[type=submit]');

      if(model.get('isValid')) {
         model.save().then(function(response) {
        //success 
        self.transitionToRoute('pagos', self.get('modeloPadre'), {queryParams: {desde: self.get('desde')}}).then(function() {
          Bodega.Notification.show('Éxito', 'Pago Confirmado');
        });
        Bodega.Utils.enableElement('button[type=submit]');
        if (self.get('desde') == 'ventas'){
          self.send('print');
        }
        }, function(response) {
          //error
          Bodega.Notification.show('Error', 'Ha ocurrido un error al confirmar el pago. ' + response, Bodega.Notification.ERROR_MSG );
          Bodega.Utils.enableElement('button[type=submit]');
        });
      }else{
        Bodega.Utils.enableElement('button[type=submit]');
      }

    },

    cancel: function() {
			if(this.get('desde') == 'compras'){
				var modeloPadre = this.get('modeloPadre');
				//this.transitionToRoute('compra.edit', modeloPadre);
				this.transitionToRoute('pagos', this.get('modeloPadre'), {queryParams: {desde: this.get('desde')}})
			}
			if(this.get('desde') == 'ventas'){
				var modeloPadre = this.get('modeloPadre');
				//this.transitionToRoute('venta.edit', modeloPadre);
				this.transitionToRoute('pagos', this.get('modeloPadre'), {queryParams: {desde: this.get('desde')}})
			}
    },
		
		aprobarDescuento: function() {
			var model = this.get('model');
			model.set('estado', 'Descuento Aprobado');
			model.set('fechaAprobacionDescuento', new Date());
			var self = this;
			model.save().then(function(response) {
        //success
        self.transitionToRoute('pagos', self.get('modeloPadre'), {queryParams: {desde: self.get('desde')}}).then(function() {
          Bodega.Notification.show('Éxito', 'Descuento Aprobado');
        });
      }, function(response) {
        //error
        model.transitionTo('uncommited');
      });
    }, 
		
		cancelarDescuento: function() {
			var model = this.get('model');
			model.set('estado', 'Descuento Rechazado');
			var self = this;
			model.save().then(function(response) {
        //success
        self.transitionToRoute('pagos', self.get('modeloPadre'), {queryParams: {desde: self.get('desde')}}).then(function() {
          Bodega.Notification.show('Éxito', 'Descuento Rechazado');
        });
      }, function(response) {
        //error
        model.transitionTo('uncommited');
      });
    }
  }
});

Bodega.PagoDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
			$('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;

      model.deleteRecord();

      model.save().then(function(response) {
        //success
        self.transitionToRoute('pagos', self.get('modeloPadre'), {queryParams: {desde: self.get('desde')}}).then(function() {
          Bodega.Notification.show('Éxito', 'Pago Invalidado');
        });
      }, function(response) {
        //error
        if(response.responseJSON){
          self.transitionToRoute('pagos', self.get('modeloPadre'), {queryParams: {desde: self.get('desde')}}).then(function() {
            Bodega.Notification.show('Error', 'Ha ocurrido un error al invalidar el pago. ' + response.responseJSON.message, Bodega.Notification.ERROR_MSG );
          });
        }

        if(response.errors){
          var errores = response.errors.base;
          if(errores){
            self.transitionToRoute('pagos', self.get('modeloPadre'), {queryParams: {desde: self.get('desde')}}).then(function() {
              for(var i=0; i<errores.length; i++){
                Bodega.Notification.show('Error', errores[i], Bodega.Notification.ERROR_MSG);
              }
            });
          }
        }
      });
    },

    cancel: function() {
			$('body').removeClass('modal-open');
      this.transitionToRoute('pagos', self.get('modeloPadre'), {queryParams: {desde: self.get('desde')}});
    }
  }
});