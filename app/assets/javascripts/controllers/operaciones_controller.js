Bodega.OperacionesIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable,
  Bodega.mixins.Filterable, {
  resource:  'operacion',
  perPage:  9
});

Bodega.OperacionesNewController = Ember.ObjectController.extend({

  formTitle: 'Nueva Operación',

  tieneCajaDestino: function() {
    var self = this;
    var cajas = self.get('cajasquery');
    self.set('cajadestinoUsuario',false);
    self.set('cajadestinoPrincipal',false);
    var iguales = false;

    if (self.get('tipoOperacionSeleccionada')) {
      if (
          (!self.get('cajaSeleccionada') || !self.get('cajaDestinoSeleccionada')) ||
          (self.get('tipoOperacionAnterior') != self.get('tipoOperacionSeleccionada'))
        ){
        console.log("Seteando cajas de nuevo");
        if(self.get('tipoOperacionSeleccionada').get('cajaDefault') === 'sucursal'){
          //self.set('cajaDefault', self.get('cajaSucursal'));
          self.set('cajaSeleccionada', self.get('cajaSucursal'));
          //self.set('cajaDestinoDefault', self.get('cajaUsuario'));
          self.set('cajaDestinoSeleccionada', self.get('cajaUsuario'));

        }else{
         // self.set('cajaDefault', self.get('cajaUsuario'));
          self.set('cajaSeleccionada', self.get('cajaUsuario'));
          //self.set('cajaDestinoDefault', self.get('cajaSucursal'));
          self.set('cajaDestinoSeleccionada', self.get('cajaSucursal'));
        }
      } else if (self.get('cajaSeleccionada').get('codigo') === self.get('cajaDestinoSeleccionada').get('codigo')) {
        iguales = true;
      }

      cajas.then(function() {
        self.set('cajas', cajas);
        var codigoOrigenSelect = self.get('cajaSeleccionada').get('codigo');
        var cajasDestino = cajas.filter(function(c) { return c.get('codigo') != codigoOrigenSelect; });
        self.set('cajasDestino', cajasDestino);
        if (iguales) {
          self.set('cajaDestinoSeleccionada', cajasDestino.objectAt(0));
        }
        self.set('saldoCajaDestinoSeleccionada', self.get('cajaDestinoSeleccionada').get('saldo'));
      });


      self.set('saldoCajaSeleccionada', self.get('cajaSeleccionada').get('saldo'));


      console.log("SET tipo operacion anterior");
      self.set('tipoOperacionAnterior', self.get('tipoOperacionSeleccionada'));

      console.log("Caja Default: " + self.get('tipoOperacionSeleccionada').get('cajaDefault'));
      console.log("Destino:" + self.get('cajaDestinoSeleccionada').get('codigo') + " Origen: " + self.get('cajaSeleccionada').get('codigo'));
      console.log(" T.O. Actual: " + self.get('tipoOperacionSeleccionada').get('codigo'));

      if (self.get('cajaDestinoSeleccionada').get('tipoCaja') == "P") {
          self.set('cajadestinoPrincipal',true);

      } else if(self.get('cajaDestinoSeleccionada').get('tipoCaja') == "U"){
           self.set('cajadestinoUsuario',true);
      }
    }
  }.observes('tipoOperacionSeleccionada','cajaSeleccionada', 'cajaDestinoSeleccionada'),

  loadCategorias: function() {
    var tipoOperacionSeleccionada = this.get('tipoOperacionSeleccionada');
    var self = this;

    if (tipoOperacionSeleccionada) {
        var categoriaOperaciones = this.store.find('categoriaOperacion',
            {'unpaged' : true, 'by_activo' : true, 'by_tipo_operacion': tipoOperacionSeleccionada.get('id')}
        );

        categoriaOperaciones.then(function() {
            self.set('categoriaOperaciones', categoriaOperaciones);
            var categoriaOperacion = categoriaOperaciones.objectAt(0);
            var model = self.get('model');

            if (categoriaOperacion) {
                self.set('categoriaOperacionSeleccionada', categoriaOperacion);
                model.set('categoriaOperacion', categoriaOperacion);

            } else {
                self.set('categoriaOperacionSeleccionada', null);
                model.set('categoriaOperacion', null);
            }
        });
    }
    else {
        //console.log('loadSucursal: tipoOperacionSeleccionada null');
    }
}.observes('tipoOperacionSeleccionada'),

  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;

      var caja = this.get('cajaSeleccionada');
      var cajaDestino = self.get('cajaDestinoSeleccionada');
      var tipoOperacion = this.get('tipoOperacionSeleccionada');
      var categoriaOperacion = this.get('categoriaOperacionSeleccionada');

      if (tipoOperacion.get('externo') && !caja.get('abierta')) {
        Bodega.Notification.show('Atención', Bodega.Messages.mensajeRequiereApertura,
                                     Bodega.Notification.WARNING_MSG);
        return;
      }

      if (tipoOperacion.get('codigo') === "cierre" && !caja.get('abierta')) {
        Bodega.Notification.show('Atención', 'La caja ya se encuentra cerrada',
                                     Bodega.Notification.WARNING_MSG);
        return;
      }

      if (tipoOperacion.get('codigo') === "apertura" && cajaDestino.get('abierta')) {
        Bodega.Notification.show('Atención', 'La caja ya se encuentra abierta',
                                     Bodega.Notification.WARNING_MSG);
        return;
      }

      var moneda = caja.get('moneda');
      var monto = this.get('monto');
      console.log("Tiene caja destiono:  " + self.get('tipoOperacionSeleccionada').get('tieneCajaDestino') + ": " + cajaDestino);
      if(self.get('tipoOperacionSeleccionada').get('tieneCajaDestino'))
      {
        model.set('cajaDestino', cajaDestino);
      }


      model.set('caja',caja);
      model.set('tipoOperacion', tipoOperacion);
      model.set('categoriaOperacion', categoriaOperacion);
      model.set('monto',monto);
      var transitionAfter = this.get('transitionAfter');
      var modelo = model;
//      moneda.then(function(response){
//        modelo.set('moneda',response);
//        console.log(response);
//        console.log("Id de la moneda: " + response.get("id"));
        if(tipoOperacion.get('codigo') == 'cierre') {
          var params = {};
          var downloadParams ={};
          downloadParams.httpMethod = 'GET';
          params.content_type = 'pdf';
          params.tipo = 'reporte_final_caja';
          usuario = caja.get('usuario');
//          usuario.then(function(response){
//            params.by_usuario = response.id;
            params.by_fecha_on = Date();
            params.by_caja_id = caja.get('id');

            model.save().then(function(response) {
              // success
              Bodega.Notification.show('Descarga.', 'El reporte se descargará.');
              downloadParams.data = params;
              Bodega.$.fileDownload("/api/v1/operaciones", downloadParams);
              self.transitionToRoute('movimientos');
            }, function(response){
              // error
            });
//          });
        } else {
          console.log(model.get('moneda'));
          model.save().then(function(response) {
            // success
            // if ()
            // this.store.find('categoriaOperacion', {'by_id' : response.get('categoriaOperacion').get('id')}).then(function(response) {
            // });
            if (transitionAfter) {
              self.transitionToRoute(transitionAfter.targetName);
            } else {
              self.transitionToRoute('movimientos');
            }


          }, function(response){
            // error
          });
        }
//      });
    },

    checkCredenciales: function(credenciales) {
        var cajaDestino = this.get('cajaDestinoSeleccionada');

        if(cajaDestino.get('tipoCaja') == 'U'){
          var credentials = {identification:cajaDestino.get('usuario').get('username'), password: this.get('passwordUsuario')};
        }else if(cajaDestino.get('tipoCaja') == 'P'){

          var credentials = {identification: this.get('identification'), password: this.get('passwordPrincipal')};
//            console.log(credencials);
        }
        this.set('passwordPrincipal', null);
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
               if(cajaDestino.get('tipoCaja') == 'U'){
                self.send('save');
               }else if(cajaDestino.get('tipoCaja') == 'P'){
                   if($.inArray('FE_autoriza_caja_sucursal', data.permisos) >= 0){
                       console.log(data.permisos);
                       self.send('save');
                   }else{
                        Bodega.Notification.show('Error','El usuario no tiene puede autorizar a la caja sucursal',Bodega.Notification.ERROR_MSG);
//                       self.set('errorMessage', '');
                   }
               }
           },
           error: function() {
               self.set('errorMessage', 'Credenciales no válidas');
           }
       });
    },





    cancel: function() {
      var model = this.get('model');
      this.transitionToRoute('movimientos');
    }
  }
});

Bodega.OperacionDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
			$('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        self.transitionToRoute('movimientos');
      });
    },

    cancel: function() {
			$('body').removeClass('modal-open');
      this.transitionToRoute('movimientos');
    }
  }
});


// Bodega.OperacionesLoginController = Ember.Controller.extend({
//   needs: ['OperacionesNew'],
//   OperacionesNew: Ember.computed.alias("controllers.OperacionesNew"),
//   actions: {
//     checkCredenciales: function(credenciales) {
//         var credentials = this.getProperties('identification', 'password');
//         this.set('password', null);
//         var self = this;
//         $.ajax({
//            url: '/api/v1/session',
//            type: 'POST',
//            data: {
//                 'username': credentials.identification,
//                 'password': credentials.password,
//                 'check_only': 1
//            },
//            accepts: 'application/json',
//            // success: function(data) {
//            //     if($.inArray('FE_editar_precio_venta', data.permisos) >= 0){
//            //          var controllers = [self.get('controllers.ventasNew'), self.get('controllers.ventaEdit')];
//            //          controllers.forEach(function(c){
//            //              if(c.get('disablePrecio')){
//            //                  c.set('disablePrecio', false);
//            //                  c.set('supervisor', credentials.identification);
//            //              }
//            //          });
//            //          self.set('identification', null);
//            //          $('.modal').modal('hide');
//            //          self.send('removeModal');
//            //     }else{
//            //          self.set('errorMessage', 'Credenciales no válidas');
//            //     }
//            // },
//            // error: function() {
//            //     self.set('errorMessage', 'Credenciales no válidas');
//            // }
//        });
//     },

//     clear: function(){
//         this.set('errorMessage', null);
//         this.set('identification', null);
//         this.set('password', null);
//         this.set('supervisor', null);
//     }
//   },

//   prueba: function(){
//     console.log(this.get('OperacionesNew'));
//   }
// });
