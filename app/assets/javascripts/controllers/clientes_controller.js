Bodega.ClientesIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable, 
  Bodega.mixins.Filterable, {
  resource:  'cliente',
  hasSearchForm: true,
  searchFormTpl: 'clientes/searchform',
  searchFormModal: '#clienteSearchForm',
  perPage:  9,
  staticFilters: {
    ignorar_cliente_default: true
  },
	
  filterToParam : {
		by_numero_cliente: 'by_numero_cliente',
		by_ciRuc: 'by_ciRuc',
		by_razon_social: 'by_razon_social',
    by_sexo: 'by_sexo',
    by_tipo_persona: 'by_tipo_persona',
    by_estado_civil: 'by_estudios_realizados',
    by_nacionalidad: 'by_nacionalidad',
    by_numero_hijos: 'by_numero_hijos',
    by_estudios_realizados: 'by_estudios_realizados',
    by_ciudad: 'by_ciudad',
    by_calificacion: 'by_calificacion',
    by_barrio: 'by_barrio',
    by_es_empleado: 'by_es_empleado',
    by_antiguedad: 'by_antiguedad',
    by_fecha_nacimiento_before: 'by_fecha_nacimiento_before',
    by_fecha_nacimiento_on: 'by_fecha_nacimiento_on',
    by_fecha_nacimiento_after: 'by_fecha_nacimiento_after',
    by_profesion: 'by_profesion',
    by_cargo: 'by_cargo',
    by_fecha_pago_sueldo_before: 'by_fecha_pago_sueldo_before',
    by_fecha_pago_sueldo_on: 'by_fecha_pago_sueldo_on',
    by_fecha_pago_sueldo_after: 'by_fecha_pago_sueldo_after',
    by_salario_mensual: 'by_salario_mensual',
    by_dias_atraso_lt: 'by_dias_atraso_lt',
    by_dias_atraso_eq: 'by_dias_atraso_eq',
    by_dias_atraso_gt: 'by_dias_atraso_gt',
    by_fecha_ingreso_informconf_before: 'by_fecha_ingreso_informconf_before',
    by_fecha_ingreso_informconf_on: 'by_fecha_ingreso_informconf_on',
    by_fecha_ingreso_informconf_after: 'by_fecha_ingreso_informconf_after',
    by_fecha_egreso_informconf_before: 'by_fecha_egreso_informconf_before',
    by_fecha_egreso_informconf_on: 'by_fecha_egreso_informconf_on',
    by_fecha_egreso_informconf_after: 'by_fecha_egreso_informconf_after'
	},

 clearSearchForm: function() {
    var self = this; 
    Ember.keys(self.filterToParam).forEach(function(f){
      self.set(f, '');
    });
  },

  actions: {
    criteriaSearch: function() {
      
      var self = this;
      var ciRuc = this.get('ciRuc');
      var nroCliente = this.get('nroCliente');
      var filters = this.get('filters');
      
      Ember.keys(self.filterToParam).forEach(function(f){
        var value = self.get(f);
        if(value){
          filters[self.filterToParam[f]] = value; 
        }
      }); 

      this.set('filters', filters);
      this.store.find('cliente', filters).then(function(model) {
        self.set('model', model);
      });
    },

    goEditCliente: function(id) {
      var cliente = this.store.find('cliente', id);
      this.transitionTo("cliente.edit", cliente);
    }
  }
  });

Bodega.ClienteBaseController = Ember.ObjectController.extend({
  
  esComerciante: false,
  esJubilado: false,
  esEmpleador: false,
  feedback: {},
  isCiudadLoaded: false,
  isEdit: false,
  vinculoFamiliarSeleccionado: null,

  loadCiudad: function() {
   
    var self = this;
    var ciudadSeleccionada = this.get('ciudadSeleccionada');
    var model = this.get('model');
    var persona = model.get('persona');
    
    if(ciudadSeleccionada) {
      var ciudades = this.store.find('ciudad', {by_codigo: ciudadSeleccionada.get('codigo')});
      ciudades.then(function() {
        var ciudad = ciudades.objectAt(0);

        if(ciudad){
          persona.set('ciudad', ciudad);
        }
      });
    }
  }.observes('ciudadSeleccionada'),
  
  loadCiudadEmpleador: function() {
   
    var self = this;
    var ciudadSeleccionada = this.get('ciudadEmpleadorSeleccionada');
    var model = this.get('model');
    
    if(ciudadSeleccionada) {
      var ciudades = this.store.find('ciudad', {by_codigo: ciudadSeleccionada.get('codigo')});
      ciudades.then(function() {
        var ciudad = ciudades.objectAt(0);

        if(ciudad){
          model.set('ciudad', ciudad);
        }
      });
    }
  }.observes('ciudadEmpleadorSeleccionada'),

  loadVinculoFamiliar: function() {
    
    var vinculoFamiliarSeleccionado = this.get('vinculoFamiliarSeleccionado');
    var ingresoFamiliar = this.get('ingresoFamiliar');
    
    if(vinculoFamiliarSeleccionado){
      var vinculos = this.store.find('vinculoFamiliar', {by_id: vinculoFamiliarSeleccionado.get('id')});
      vinculos.then(function() {
        var vinculo = vinculos.objectAt(0);

        if(vinculo){
          ingresoFamiliar.set('vinculoFamiliar', vinculo);
        }
      });
    }
  }.observes('vinculoFamiliarSeleccionado'),
  
  loadTipoDocumento: function() {
    var self = this;
    var tipoDocumentoSeleccionado = self.get('tipoDocumentoSeleccionado');
    var documento = self.get('documento');
    
    if(tipoDocumentoSeleccionado){
      var tipos = self.store.find('tipoDocumento', {by_id: tipoDocumentoSeleccionado.get('id')});
      tipos.then(function() {
        var tipo = tipos.objectAt(0);
        if(tipo){
          documento.set('tipoDocumento', tipo);
          self.set('tipoDocumentoSeleccionado', self.get('documento').get('tipoDocumento'));
        }
      });

    }
  }.observes('tipoDocumentoSeleccionado'),

  nombreORazonSocial: function() {
    var tipoPersona = this.get('persona.tipoPersona');

    if(tipoPersona === 'Física'){
      this.set('mostrarRazonSocial', false);
    }
    else if(tipoPersona === 'Jurídica'){
      this.set('mostrarRazonSocial', true);
    }

  }.observes('persona.tipoPersona'),

  actions: {
    agregarReferencia: function() {
      var model = this.get('model');
      var referencia = this.get('referencia');
      var referencias = this.get('listadoReferencias');
      var nuevaReferencia = this.store.createRecord('referencia');
      nuevaReferencia.set('nombre', referencia.get('nombre'));
      nuevaReferencia.set('telefono', referencia.get('telefono'));
      nuevaReferencia.set('tipoReferencia', referencia.get('tipoReferencia'));
      nuevaReferencia.set('tipoCuenta', referencia.get('tipoCuenta'));
      nuevaReferencia.set('activa', referencia.get('activa'));
      referencias.addRecord(nuevaReferencia);
      referencia.set('nombre', '');
      referencia.set('telefono', '');
      referencia.set('tipoCuenta', '');
      referencia.set('activa', false);
    },

    borrarReferencia: function(ref) {
      this.get('listadoReferencias').removeRecord(ref);
      this.get('controllers.application').set('containerHeight', Bodega.newHeightWrapper()); 
    },
    
    agregarIngreso: function() {
      var model = this.get('model');
      var ingresoFamiliar = this.get('ingresoFamiliar');
      var ingresosFamiliares = this.get('ingresosFamiliares');
      var nuevoIngresoFamiliar = this.store.createRecord('ingresoFamiliar');
      nuevoIngresoFamiliar.set('ingresoMensual', ingresoFamiliar.get('ingresoMensual'));
      nuevoIngresoFamiliar.set('vinculoFamiliar', ingresoFamiliar.get('vinculoFamiliar'));
      ingresosFamiliares.addRecord(nuevoIngresoFamiliar);
      ingresoFamiliar.set('ingresoMensual', '');
    },

    borrarIngreso: function(ing) {
      this.get('ingresosFamiliares').removeRecord(ing);
      this.get('controllers.application').set('containerHeight', Bodega.newHeightWrapper()); 
    },
    
    agregarDocumento: function() {
  
      var model = this.get('model');
      var documento = this.get('documento');
      var documentos = this.get('clienteDocumentos');
      var nuevoDocumento = this.store.createRecord('documento');
      nuevoDocumento.set('nombre', documento.get('nombre'));
      nuevoDocumento.set('estado', documento.get('estado'));
      nuevoDocumento.set('urlAdjunto', documento.get('urlAdjunto'));
      nuevoDocumento.set('tipoDocumento', documento.get('tipoDocumento'));
      var mfu = documento.get('modelsFileUpload');
      nuevoDocumento.set('modelsFileUpload', mfu);
      
      if(mfu.length) {
        // generamos el UUID para el adjunto
        nuevoDocumento.set('adjuntoUuid', uuid.v4());
      }
      documentos.addRecord(nuevoDocumento);
      documento.set('nombre', '');
      documento.set('estado', '');
      documento.set('urlAdjunto', '');
      documento.set('modelsFileUpload', []);
    },

    borrarDocumento: function(doc) {
      this.get('clienteDocumentos').removeRecord(doc);
      this.get('controllers.application').set('containerHeight', Bodega.newHeightWrapper()); 
    }
  }

});


Bodega.ClientesNewController = Bodega.ClienteBaseController.extend({

  formTitle: 'Nuevo Cliente',

  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      var documentos = this.get('clienteDocumentos');
      var modelsFileUploadMap = {};
      Bodega.Utils.disableElement('button[type=submit]');

      var mostrarRazonSocial = this.get('mostrarRazonSocial');
      if(!mostrarRazonSocial){
        this.set('persona.razonSocial', this.get('persona.nombre') + ' ' + this.get('persona.apellido'));
      }

      documentos.forEach(function(doc) {
        var mfu = doc.get('modelsFileUpload') || [];
        
        if(mfu.length) {
          modelsFileUploadMap[doc.get('adjuntoUuid')] = mfu;
        }
      });

      if(model.get('isValid')) {
        model.save().then(function(response) {
          
          var documentosResponse = self.store.find('documento', {by_cliente: response.get('id')}); 
          documentosResponse.then(function(docs) {
            
            docs.forEach(function(doc) {
              
              if(!doc.get('id')) {
                return;
              }

              var modelsFileUpload = modelsFileUploadMap[doc.get('adjuntoUuid')];
              if (modelsFileUpload && modelsFileUpload.length > 0) {
                 modelsFileUpload[0].uploadFile(doc.get('id'), 'documentos', 'adjunto').then(function(data) {
                  doc.set('urlAdjunto', data.url);  
                });
              }
            });

            // success
            self.transitionToRoute('clientes').then(function () {
              Bodega.Notification.show('Exito', 'El cliente se ha guardado.');
              Bodega.Utils.enableElement('button[type=submit]');
              self.set('feedback', {});
            });
          });

        }, function(response){
          // error
          self.set('feedback', response.errors);
          Bodega.Utils.enableElement('button[type=submit]');
        });
      }else{
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },

    cancel: function() {
      var model = this.get('model');
      this.transitionToRoute('clientes');
    }
  }
});

Bodega.ClienteEditController = Bodega.ClienteBaseController.extend({

  formTitle: 'Editar Cliente',
  isEdit: true,

  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      var clienteDocumentos = this.get('clienteDocumentos');
      var modelsFileUploadMap = {};
      Bodega.Utils.disableElement('button[type=submit]');

      var mostrarRazonSocial = this.get('mostrarRazonSocial');
      if(!mostrarRazonSocial){
        this.set('persona.razonSocial', this.get('persona.nombre') + ' ' + this.get('persona.apellido'));
      }
      
      clienteDocumentos.forEach(function(doc) {
        var mfu = doc.get('modelsFileUpload') || [];
        
        if(mfu.length) {
          modelsFileUploadMap[doc.get('adjuntoUuid')] = mfu;
        }
      });

      if(model.get('isValid')) {
        model.save().then(function(response) {
         
          var documentos = self.store.find('documento', {by_cliente: model.get('id')}); 
          documentos.then(function(docs) {
            
            docs.forEach(function(doc) {
              
              if(!doc.get('id')) {
                return;
              }

              var modelsFileUpload = modelsFileUploadMap[doc.get('adjuntoUuid')];
              if (modelsFileUpload && modelsFileUpload.length > 0) {
                modelsFileUpload[0].uploadFile(doc.get('id'), 'documentos', 'adjunto').then(function(data) {
                  doc.set('urlAdjunto', data.url);  
                });
              }
            });

            // success
            self.transitionToRoute('clientes').then(function () {
              Bodega.Notification.show('Exito', 'El cliente se ha actualizado.');
              Bodega.Utils.enableElement('button[type=submit]');
            });
          });
        }, function(response) {
          //error
          Bodega.Utils.enableElement('button[type=submit]');
        });
      }else{
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },

    generarLegajo: function() {
			Bodega.Notification.show('Descarga.', 'El reporte se descargará.');
      var filters = {};
      var downloadParams ={};
      downloadParams.httpMethod = 'GET';
      filters.content_type = 'pdf';
			filters.report_type = 'reporte_legajo_cliente';
      downloadParams.data = filters;
      var model = this.get('model');

      Bodega.$.fileDownload("/api/v1/clientes/" + model.get('id'), downloadParams).done(function() {
        Bodega.$.fileDownload("/adjuntos/" + model.get('id') + "/adjuntos-" + model.get('persona').get('ciRuc')  + ".zip"); 
      }); 
    },

    cancel: function() {
      this.transitionToRoute('clientes');
    }
  }
});

Bodega.ClienteDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        Bodega.Notification.show('Exito', 'El cliente se ha eliminado.');
        self.transitionToRoute('clientes');
      });
    },

    cancel: function() {
			$('body').removeClass('modal-open');
      this.transitionToRoute('clientes');
    }
  }
});

/*******************************************************************************************/
Bodega.ReferenciasIndexController = Ember.ArrayController.extend(Bodega.mixins.Pageable,
  Bodega.mixins.Filterable,{
  staticFilters : {},
  resource:  'referencia'
});
