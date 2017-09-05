Bodega.ConsultasIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable,
  Bodega.mixins.Filterable, {
    queryParams: ['especialidad'],
    resource: 'consulta',
    perPage: 15
  });

Bodega.ConsultaBaseController = Bodega.ClinicaBaseController.extend({
  enters: 2,
  feedback: {},
  needs: ['application'],
  agregandoDetalleLista: false,

  loadColaborador: function() {
    console.log('LOAD COLABORADOR IF EXIST ');
    var self = this;
    var especialidad = this.get('especialidadSeleccionada');
    var model = self.get('model');
    if (especialidad) {
      var medicos = this.store.find('colaborador', { 'by_especialidad_id': especialidad.get('id') ,'unpaged': true, 'by_activo':true});

      medicos.then(function() {
        self.set('medicos', medicos);

        var medico = medicos.objectAt(0);
        if (medico) {
          self.set('medicoSeleccionado', medico);
        } else {
          self.set('medicoSeleccionado', null);
        }
      });
    }
  }.observes('especialidadSeleccionada'),

  imprimirReceta: function(consulta){
    var params = {};
    var downloadParams = {};
    params.content_type = 'pdf';
    params.tipo = 'receta'
    downloadParams.httpMethod = 'GET';
    params.consulta_id = consulta.get('id');
    downloadParams.data = params;
    Bodega.Utils.printPdf('/api/v1/consultas/', params);
  },

  actions: {
    agregarDetalle: function() {
      console.log('ConsultasBaseController->agregarDetalle');
      var producto = this.get('productoSeleccionado');
      var detalles = this.get('detalles');
      var self = this;
      if (producto) {
        this.set('agregandoDetalle', true);
        var detalle = self.get('detNuevo');
        if (this.get('cantidad')) {
          detalle.set('cantidad', this.get('cantidad'));
        } else {
          Bodega.Notification.show('Error', 'Seleccione una cantidad', Bodega.Notification.ERROR_MSG);
          return;
        }
        //establecer el producto al nuevo detalle.
        detalle.set('producto', producto);

        //adjuntar a la lista de detalles
        this.set('detNuevo', this.store.createRecord('consultaDetalle'));
        detalles.addRecord(detalle);
        detalle.set('dirty', false);
        this.set('agregandoDetalle', false);
        this.set('cantidad', 0);
        //Para evitar que se mueva de vista si agrego un detalle y no guardo.
        //this.get('controllers.application').set('containerHeight', Bodega.newHeightWrapper(true));
        // this.clearProducto();
        // $("#codigoBarra").focus();
        if (producto.get('necesitaConsentimientoFirmado')) {
          especialidad = producto.get('especialidad');
          especialidad.then(function() {
            var params = {};
            var downloadParams = {};
            params.content_type = 'pdf';
            downloadParams.httpMethod = 'GET';
            if (especialidad.get('codigo') == 'CIR') {
              params.especialidad = 'CIRUGIA';
              params.revocacion = false;
            } else {
              params.especialidad = 'TRATAMIENTO';
              if (self.get('medicoSeleccionado.id')) {
                params.colaborador_id = self.get('medicoSeleccionado.id');
              } else {
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
      } else {
        Bodega.Notification.show('Error', 'Seleccione un tratamiento', Bodega.Notification.ERROR_MSG);
        return;
      }
      this.set('count', 0);
    },

    revocacion: function(producto, valor) {
      var self = this;
      var medico = this.get('medicoSeleccionado');
      especialidad = producto.get('especialidad');
      if (!valor) {
        especialidad.then(function() {
          console.log(especialidad.get('codigo'));
          var params = {};
          var downloadParams = {};
          params.content_type = 'pdf';
          downloadParams.httpMethod = 'GET';
          if (especialidad.get('codigo') == 'CIR') {
            params.especialidad = 'CIRUGIA';
            params.revocacion = true;
            if (self.get('medicoSeleccionado.id')) {
              params.colaborador_id = self.get('medicoSeleccionado.id');
            } else {
              Bodega.Notification.show('Error', 'Seleccione un medico', Bodega.Notification.ERROR_MSG);
              return;
            }
          } else {
            return;
          }
          params.paciente_id = self.get('pacienteSeleccionado.id');
          downloadParams.data = params;
          console.log(downloadParams);
          Bodega.Utils.printPdf('/api/v1/consultas/', params);
          Bodega.Notification.show('Descarga.', 'El reporte se descargará.');
          // Bodega.$.fileDownload("/api/v1/consultas", downloadParams);
        });
      }
    },
    agregarLista: function() {
      var medicoSeleccionado = this.get('medicoSeleccionado');
      var especialidadSeleccionada = this.get('especialidadSeleccionada');
      var agregandoDetalleLista = this.get('agregandoDetalleLista');
      var fechaAgenda = this.get('fechaAgenda');
      var detalle = this.get('detNuevoLista');

      console.log(medicoSeleccionado);
      // console.log(especialidadSeleccionada);
      if (especialidadSeleccionada && agregandoDetalleLista == false) {
        this.set('agregandoDetalleLista', true);
        var listas = this.get('listas');
        console.log('listascontroller', listas);
        detalle.set('especialidad', especialidadSeleccionada)
        detalle.set('fechaAgenda',fechaAgenda);
        detalle.set('colaborador', medicoSeleccionado);
        this.set('detNuevoLista', this.store.createRecord('consultaLista'));
        listas.addRecord(detalle)
        console.log("listas", listas);
        this.set('agregandoDetalleLista', false);
      }
    },
    borrarDetalleLista: function(detalle) {
      console.log("ConsultasBaseController->borrarDetalle");
      this.get('listas').removeRecord(detalle);
      detalle.deleteRecord();
      // detalle.save();
      this.get('controllers.application').set('containerHeight', Bodega.newHeightWrapper());
    },

    borrarDetalle: function(detalle) {
      console.log("ConsultasBaseController->borrarDetalle");
      this.get('detalles').removeRecord(detalle);
      detalle.deleteRecord();
      // detalle.save();
      this.get('controllers.application').set('containerHeight', Bodega.newHeightWrapper());
    },

    contarEnters: function() {
      console.log("ConsultasBaseController->action->contarEnters " + this.get('count'));
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
      console.log("ConsultasBaseController->action->resetCount");
      var count = this.get('codigoBarra');
      if (count === "") {
        this.set('count', 0);
      }
    }.observes('codigoBarra'),

    cargarProducto: function() {
      console.log("InventariossBaseController->action->cargarProducto");
      this.set('count', 1);
      var producto = this.get('productoSeleccionado');
      if (producto) {
        this.send('agregarDetalle');
      } else {
        this.loadProducto();
      }
    },

    save: function() {
      Bodega.Utils.disableElement('button[type=submit]');
      var model = this.get('model');
      var self = this;
      var detalles = this.get('detalles');
      var listas = this.get('listas');
      console.log('Detalles: ', detalles);
      console.log("listas", listas);
      console.log("model", model);
      console.log(!model.get('id'), listas.get('length'));
      console.log(!model.get('id'), detalles.get('length'));
      if(!model.get('id') && listas.get('length') <= 0){
        Bodega.Notification.show('Atención', 'No agregó consultas de ninguna especialidad', Bodega.Notification.WARNING_MSG);
        Bodega.Utils.enableElement('button[type=submit]');
      }else if (!model.get('id') && listas.get('length') > 0){
        console.log("PACIENTE",  this.get('pacienteSeleccionado'));
        this.set('paciente', this.get('pacienteSeleccionado'));

        console.log("this.get('consultaDetalles')", this.get('model.consultaDetalles'));
        console.log("this.get('consultaListas')", this.get('model.consultaListas'));
        console.log("this.get('detalles')", this.get('detalles'));
        if (!this.get('paciente')) {
          Bodega.Notification.show('Error', 'No se encuentra el paciente', Bodega.Notification.ERROR_MSG);
          Bodega.Utils.enableElement('button[type=submit]');
          return;
        }

        if (!this.get('atendiendo')) {
          model.set('estado', 'AGENDADO');
        } else {
          model.set('estado', 'ATENDIDO');
        }

        if (model.get('isValid')) {
          model.save().then(function(response) {
            //success

            self.set('feedback', {});
            console.log('Se guardó correctamente');
            self.transitionToRoute('consultas');
          }, function(response) {
            console.log(response);
            self.set('feedback', response.errors);
            Bodega.Notification.show('Error', 'No se pudo crear el consulta.', Bodega.Notification.ERROR_MSG);
            Bodega.Utils.enableElement('button[type=submit]');
          });
        } else {
          Bodega.Utils.enableElement('button[type=submit]');
        }
      }else {
        if (!this.get('paciente')) {
          Bodega.Notification.show('Error', 'No se encuentra el paciente', Bodega.Notification.ERROR_MSG);
          Bodega.Utils.enableElement('button[type=submit]');
          return;
        }
        if (!this.get('medicoSeleccionado') && this.get('atendiendo')) {
          Bodega.Notification.show('Error', 'Seleccione un médico', Bodega.Notification.ERROR_MSG);
          Bodega.Utils.enableElement('button[type=submit]');
          return;
        }
        model.set('especialidad',this.get('especialidadSeleccionada'));
        model.set('fechaAgenda',this.get('fechaAgenda'));
        model.set('colaborador',this.get('medicoSeleccionado'));
        if (!this.get('atendiendo')) {
          model.set('estado', 'AGENDADO');
        } else {
          model.set('estado', 'ATENDIDO');
        }
        if (model.get('isValid')) {
          model.save().then(function(response) {
            //success
            self.set('feedback', {});
            console.log('Se guardó correctamente');
            self.transitionToRoute('consultas');
          }, function(response) {
            console.log(response);
            self.set('feedback', response.errors);
            Bodega.Notification.show('Error', 'No se pudo crear el consulta.', Bodega.Notification.ERROR_MSG);
            Bodega.Utils.enableElement('button[type=submit]');
          });
        } else {
          Bodega.Utils.enableElement('button[type=submit]');
        }
      }
    },

    saveImprimir: function() {
      Bodega.Utils.disableElement('button[type=submit]');
      var model = this.get('model');
      var self = this;
      var detalles = this.get('detalles');
      var listas = this.get('listas');
      console.log('Detalles: ', detalles);
      console.log("listas", listas);
      console.log("model", model);
      console.log(!model.get('id'), listas.get('length'));
      console.log(!model.get('id'), detalles.get('length'));
      if(!model.get('id') && listas.get('length') <= 0){
        Bodega.Notification.show('Atención', 'No agregó consultas de ninguna especialidad', Bodega.Notification.WARNING_MSG);
        Bodega.Utils.enableElement('button[type=submit]');
      }else if (!model.get('id') && listas.get('length') > 0){
        console.log("PACIENTE",  this.get('pacienteSeleccionado'));
        this.set('paciente', this.get('pacienteSeleccionado'));

        console.log("this.get('consultaDetalles')", this.get('model.consultaDetalles'));
        console.log("this.get('consultaListas')", this.get('model.consultaListas'));
        console.log("this.get('detalles')", this.get('detalles'));
        if (!this.get('paciente')) {
          Bodega.Notification.show('Error', 'No se encuentra el paciente', Bodega.Notification.ERROR_MSG);
          Bodega.Utils.enableElement('button[type=submit]');
          return;
        }

        if (!this.get('atendiendo')) {
          model.set('estado', 'AGENDADO');
        } else {
          model.set('estado', 'ATENDIDO');
        }

        if (model.get('isValid')) {
          model.save().then(function(response) {
            //success

            self.set('feedback', {});
            console.log('Se guardó correctamente');
            self.transitionToRoute('consultas');
          }, function(response) {
            console.log(response);
            self.set('feedback', response.errors);
            Bodega.Notification.show('Error', 'No se pudo crear el consulta.', Bodega.Notification.ERROR_MSG);
            Bodega.Utils.enableElement('button[type=submit]');
          });
        } else {
          Bodega.Utils.enableElement('button[type=submit]');
        }
      }else {
        if (!this.get('paciente')) {
          Bodega.Notification.show('Error', 'No se encuentra el paciente', Bodega.Notification.ERROR_MSG);
          Bodega.Utils.enableElement('button[type=submit]');
          return;
        }
        model.set('especialidad',this.get('especialidadSeleccionada'));
        model.set('fechaAgenda',this.get('fechaAgenda'));
        model.set('colaborador',this.get('medicoSeleccionado'));
        if (!this.get('atendiendo')) {
          model.set('estado', 'AGENDADO');
        } else {
          model.set('estado', 'ATENDIDO');
        }
        if (model.get('isValid')) {
          model.save().then(function(response) {
            //success
            self.imprimirReceta(response);
            self.set('feedback', {});
            console.log('Se guardó correctamente');
            self.transitionToRoute('consultas');
          }, function(response) {
            console.log(response);
            self.set('feedback', response.errors);
            Bodega.Notification.show('Error', 'No se pudo crear el consulta.', Bodega.Notification.ERROR_MSG);
            Bodega.Utils.enableElement('button[type=submit]');
          });
        } else {
          Bodega.Utils.enableElement('button[type=submit]');
        }
      }
    },

  }

});


Bodega.ConsultasNewController = Bodega.ConsultaBaseController.extend({

  formTitle: 'Nuevo Consulta',
  actions: {

    cancel: function() {
      var model = this.get('model');
      model.deleteRecord();
      this.transitionToRoute('consultas');
    }
  }
});

Bodega.ConsultaEditController = Bodega.ConsultaBaseController.extend({
  queryParams: ['accion'],
  formTitle: 'Editar Consulta',
  detalleTitle: 'Tratamientos Realizados',
  accion: null,

  actions: {
    cancel: function() {
      this.transitionToRoute('consultas');
    }
  }
});

Bodega.ConsultaDeleteController = Bodega.ColaboradorBaseController.extend({

  actions: {
    deleteRecord: function() {
      $('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        self.transitionToRoute('consultas');
      });
    },

    cancel: function() {
      $('body').removeClass('modal-open');
      this.transitionToRoute('consultas');
    }
  }
});
