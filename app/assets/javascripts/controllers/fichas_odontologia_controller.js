Bodega.FichasOdontologiaBaseController = Bodega.ClinicaBaseController.extend({
  queryParams: ['paciente_id', 'consulta_id'],
  paciente_id: null,
  consulta_id: null,
  needs: ['application'],
  // listaTratamientos: Ember.computed('tratamientos.@each.eliminado', function() {
  //   return this.get('tratamientos').filterBy('eliminado', false);
  // }),

  getNewModel: function(newField) {
    return Ember.Object.create({
      diente: null,
      tratamiento: null,
      estado: null,
      eliminado: false
    });
  },
  loadFromSearchWidget: function () {
    if (!this.get('agregandoDetalle')) {
        console.log("ConsultassBaseController->loadFromSearchWidget agregandoDetalle false");
        var productoSeleccionado = this.get('productoSeleccionadoSW');
        ////console.log(productoSeleccionado);
        if (productoSeleccionado && productoSeleccionado.get('id') !== null) {
            console.log("ConsultassBaseController->loadFromSearchWidget codigoBarra: " + this.get('codigoBarra'));
            var codigoBarraSW = productoSeleccionado.get('codigoBarra');
            this.set('codigoBarra', codigoBarraSW);
            this.loadProducto();
            console.log("ConsultassBaseController->loadFromSearchWidget termino la carga");
        }
    }
  }.observes('productoSeleccionadoSW'),

  loadProducto: function(){
    console.log('ConsultasBaseController->loadProducto');
    var codigoBarra = this.get('codigoBarra');
    var self = this;
    if (codigoBarra) {
      var productos = this.store.find('producto', {'codigo_barra' : codigoBarra});
      productos.then(function(){
        var producto = productos.objectAt(0);
        var model = self.get('model');
        var detalle = self.get('detNuevo');
        if (producto) {
          self.set('productoSeleccionado', producto);
          self.set('codigoBarra', producto.get('codigoBarra'));
          self.set('descripcionSW',producto.get('descripcion'));
          detalle.set('producto', producto);
          var cantidad = 0;
          detalle.set('cantidad', cantidad);
          $("#cantidad").focus();
        } else {
          self.set('productoSeleccionado', null);
          detalle.set('cantidad', 0);
          $("#codigoBarra").focus();
        }
      });
    }
  },
  clearProducto: function () {
    console.log("ConsultassBaseController->clearProducto: " + !this.get('agregandoDetalle'));
    if (!this.get('agregandoDetalle')) {
      this.set('productoSeleccionado', null);
      this.set('productoSeleccionadoSW', null);
      this.set('descripcionSW', '');
      var detalle = this.get('detNuevo');
      if(detalle){
        detalle.set('producto', null);
        detalle.set('cantidad', 0);
      }
    }
  }.observes('codigoBarra'),
  actions: {
    agregarDetalle: function() {
      var producto = this.get('productoSeleccionado');
      var detalles = this.get('detalles');
      var detalle = this.get('detNuevo');
      var self = this;
      detalle.set("referenciaId", detalle.get("referenciaId").id);
      if (producto) {
        this.set('agregandoDetalle', true);
        //establecer el producto al nuevo detalle.
        detalle.set('producto', producto);
        //adjuntar a la lista de detalles
        this.set('descripcionSW', '');
        this.set('detNuevo', this.store.createRecord('consultaDetalle'));
        detalles.addRecord(detalle);
        detalle.set('dirty', false);
        this.set('productoSeleccionado', null);
        this.set('productoSeleccionadoSW', null);
        this.set('codigoBarra', null);
        this.set('agregandoDetalle', false);
        this.set('cantidad', null);
        //Para evitar que se mueva de vista si agrego un detalle y no guardo.
        //this.get('controllers.application').set('containerHeight', Bodega.newHeightWrapper(true));
        this.clearProducto();
        $("#codigoBarra").focus();
        if(producto.get('necesitaConsentimientoFirmado')){
          especialidad = producto.get('especialidad');
          especialidad.then(function(){
            var params = {};
            var downloadParams = {};
            params.content_type = 'pdf';
            downloadParams.httpMethod = 'GET';
            if (especialidad.get('codigo') == 'CIR') {
              params.especialidad = 'CIRUGIA';
              params.revocacion = false;
            }else {
              params.especialidad = 'TRATAMIENTO';
              if(self.get('medicoSeleccionado.id')){
                params.colaborador_id = self.get('medicoSeleccionado.id');
              }else {
                Bodega.Notification.show('Error', 'Seleccione un medico', Bodega.Notification.ERROR_MSG);
                return;
              }
            }
            params.paciente_id = self.get('pacienteSeleccionado.id');
            downloadParams.data = params;
            console.log(downloadParams);
            Bodega.Utils.printPdf('/api/v1/consultas/', params);
            Bodega.Notification.show('Descarga.', 'El reporte se descargará.');
            // Bodega.$.fileDownload("/api/v1/consultas", downloadParams);
          });
        }
      }
    },
    borrarDetalle: function(detalle) {
      this.get('detalles').removeRecord(detalle);
      detalle.deleteRecord();
      detalle.save();
      this.get('controllers.application').set('containerHeight', Bodega.newHeightWrapper());
    },
    updateOdontograma: function(data) {
      //TODO:
      console.log("TODO!");
    },

    save: function() {
      var self = this;
      var model = this.get('model');
      Bodega.Utils.disableElement('button[type=submit]');
      // model.set('datos', this.get('datosDto'));
      model.set('paciente', this.get('pacienteActual'));
      model.set('consultaId', this.get('consulta_id'));
      console.log('PACIENTE', model.get('paciente'));
      if (model.get('isValid')) {
        model.set('recienNacido', this.get('recienNacido'));
        model.set('examenClinico', this.get('examenClinico'));
        model.set('odontograma', this.get('odontograma'));
        model.set('preescolarAdolescente', this.get('preescolarAdolescente'));
	//model.set('consultaDetalles', this.get('detalles'));
	var detalles = this.get('detalles');
	console.log("##################################");
	console.log("detalle --> ", detalles);
	console.log("##################################");
        model.save().then(function(response) {
          self.store.find('paciente', { id: self.get('paciente_id') }).then(function(response) {
            if (self.get('consulta_id')) {
              self.transitionToRoute('consulta.edit', self.get('consulta_id')).then(function() {
                Bodega.Notification.show('Éxito', 'La ficha de odontología se ha modificado.');
                Bodega.Utils.enableElement('button[type=submit]');
              });
            } else {
              self.transitionToRoute('paciente.edit', response.objectAt(0)).then(function() {
                Bodega.Notification.show('Éxito', 'La ficha de odontología se ha modificado.');
                Bodega.Utils.enableElement('button[type=submit]');
              });
            }
          });
        }, function(response) {
          Bodega.Notification.show('Error', 'La ficha de odontología no se pudo crear', 'error');
          Bodega.Utils.enableElement('button[type=submit]');
          model.transitionTo('uncommitted');
        });
      } else {
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },
    cancel: function() {
      var model = this.get('model');
      model.deleteRecord();
    }

  }
});

Bodega.FichasOdontologiaNewController = Bodega.FichasOdontologiaBaseController.extend({
  formTitle: 'Nueva Ficha Odontologia',
  self: this,
  queryParams: ['paciente_id'],
  paciente_id: null
});


Bodega.FichaOdontologiaEditController = Bodega.FichasOdontologiaBaseController.extend({
  formTitle: 'Editar Ficha Odontología',
  self: this,
  queryParams: ['paciente_id'],
  paciente_id: null
});
