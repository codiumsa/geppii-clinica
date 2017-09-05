Bodega.ClientesIndexRoute = Bodega.AuthenticatedRoute.extend({
  
  model: function() {
    return this.store.find('cliente', {page: 1, ignorar_cliente_default: true});
  },
  
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.ClienteRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.ClienteBaseRoute = Bodega.AuthenticatedRoute.extend({

  setupCommonProps: function(controller, model) {
  
    controller.set('model', model);
    controller.set('tipoPersonas', ["Física", "Jurídica"]);
    controller.set('jubiladoComercianteOpts', ["Jubilado", "Comerciante"]);
    controller.set('tiposReferencia', ["Comercial", "Personal", "Bancaria"]);
    controller.set('estadoCivilOpts', ["Soltero/a", "Casado/a", "Divorciado/a", "Viudo/a"]);
    controller.set('perfilLaboral', '');
    controller.set('perfilesLaborales', ['Empleador', 'Jubilado', 'Comerciante']);
    controller.set('sexos', ['Masculino', 'Femenino']);
    controller.set('estudiosRealizados', ['Primario', 'Secundario', 'Terciario']);
    controller.set('tiposDomicilios', ['Propia', 'Alquilada', 'Familiar']);
    
    var nuevaReferencia = this.store.createRecord('referencia');
    controller.set('referencia', nuevaReferencia);
    
    var referencias = model.get('referencias');
    referencias.then(function(response) {
      controller.set('listadoReferencias', response);
    });

    var ingresoFamiliar = this.store.createRecord('ingresoFamiliar');
    controller.set('ingresoFamiliar', ingresoFamiliar);
    
    var ingresosFamiliares = model.get('ingresoFamiliares');
    ingresosFamiliares.then(function(response) {
      controller.set('ingresosFamiliares', response);
    });

    var documento = this.store.createRecord('documento');
    documento.set('modelsFileUpload', []);
    controller.set('documento', documento);
    
    var documentos = model.get('documentos');
    documentos.then(function(response) {
      controller.set('clienteDocumentos', response);
    });

    this.store.find('vinculoFamiliar', {unpaged: true}).then(function(response){
      controller.set('vinculosFamiliares', response);
      controller.set('vinculoFamiliarSeleccionado', response.objectAt(0));
  });
    
    this.store.find('tipoDocumento', {unpaged: true}).then(function(response){
      controller.set('tiposDocumentos', response);
      controller.set('tipoDocumentoSeleccionado', response.objectAt(0));
    });
  }
});


Bodega.ClienteEditRoute = Bodega.ClienteBaseRoute.extend({
  model: function(params) {
    return this.modelFor('cliente');
  },
  
  setupController: function(controller, model) {
    
    this.setupCommonProps(controller, model);

    var persona = model.get('persona');
    var conyugue = persona.get('conyugue');
    console.log('PERSONA', persona);
    console.log('CONYUGUE', conyugue);

    
    if(!conyugue){
      persona.set('conyugue', this.store.createRecord('conyugue'));
      console.log('PERSONA', persona);
    }
    var ciudad = persona.get('ciudad');

    this.store.find('ciudad', {unpaged: true}).then(function(response){
      controller.set('ciudades', response);
      if(ciudad){
        controller.set('ciudadDefault', ciudad.get('codigo'));
        controller.set('ciudadEmpleadorDefault', ciudad.get('codigo'));
      } else{
        controller.set('ciudadDefault', response.objectAt(0).get('codigo'));
        controller.set('ciudadEmpleadorDefault', response.objectAt(0).get('codigo'));
      }
    });
  },

  renderTemplate: function() {
    this.render('clientes.new', {
      controller: 'clienteEdit'
    });
  }
});

Bodega.ClientesNewRoute = Bodega.ClienteBaseRoute.extend({

  model: function() {
    var model =  this.store.createRecord('cliente');
    var persona = this.store.createRecord('persona');
    var conyugue = this.store.createRecord('conyugue');
    persona.set('conyugue', conyugue);
    model.set('persona', persona);
    console.log(model.get('persona')); 
    
    return model;
  },
  
  setupController: function(controller, model) {
    
    this.setupCommonProps(controller, model);
    
    this.store.find('ciudad', {unpaged: true}).then(function(response){
      controller.set('ciudades', response);
      controller.set('ciudadDefault', response.objectAt(0).get('codigo'));
      controller.set('ciudadEmpleadorDefault', response.objectAt(0).get('codigo'));
    });
  }
});

Bodega.ClienteDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('cliente');
  },

  renderTemplate: function() {
    this.render('clientes.delete', {
      controller: 'clienteDelete'
    });
  }
});

Bodega.ReferenciasIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    var cliente = this.modelFor('cliente');
    var referencias =  this.store.find('referencia', {by_cliente: cliente.id});
    return referencias;
  },

  renderTemplate: function() {
    this.render('clientes.referencias.index', {
      controller: 'referenciasIndex'
    });
  },

  setupController: function(controller, model) {
    controller.set('model', model);

    var cliente = this.modelFor('cliente');
    controller.set('staticFilters', {by_cliente: cliente.get('id')});
  }

});
