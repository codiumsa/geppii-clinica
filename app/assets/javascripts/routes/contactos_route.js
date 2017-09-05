Bodega.ContactosIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('contacto', { page: 1 });
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.ContactoRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.ContactoEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('contacto');
  },

  renderTemplate: function() {
    this.render('contactos.new', {
      controller: 'contactoEdit'
    });
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    var self = this;

    var sponsor = this.store.find('sponsor', model._data.sponsor.id);
    var detalles = model.get('contactoDetalles');
    detalles.then(function(response){
      controller.set('detalles', response);
    });
    // controller.set('mostrarMoneda',true);


    controller.set('estados',['Primer Contacto','Volver a llamar','Comprometido','Comprometido In Kind','Recibido','Recibido In Kind','Finalizado']);
    controller.set('estadoSeleccionado','Primer Contacto');

    var detalles = model.get('contactoDetalles');
    detalles.then(function(){
      controller.set('detalles',detalles);
    });

    var parametroMultimoneda = this.store.find('parametrosEmpresa', { 'by_soporta_multimoneda': true, 'unpaged': true });
    parametroMultimoneda.then(function() {
      if (parametroMultimoneda.objectAt(0)) {
        console.log("Seteando multimoneda...");
        controller.set('soportaMultimoneda', true);
      }else {
        controller.set('soportaMultimoneda', false);
      }
    });

    this.store.find('moneda', { 'by_activo': true }).then(function(response) {
      controller.set('monedas', response);
      controller.set('monedaSeleccionada',response.objectAt(0));
    });

    sponsor.then(function(response) {
      console.log(response);
      var ciRuc = response.get('persona.ciRuc');
      controller.set('sponsorSeleccionado',response);
      controller.set('sponsorSeleccionadoText',response.get('razonSocial'));
      controller.set('loading', true);
      controller.set('ciRuc', ciRuc);
      controller.set('sponsorActual', response);
      model.set('sponsor', response);

      var campanhas = self.store.find('campanha', {
        'by_vigente': true
      });

      campanhas.then(function(response) {
        controller.set('campanhas', response);
        if (model._data.campanha) {
          response.forEach(function(campanha) {
            if (campanha.id === model._data.campanha.id) {
              controller.set('campanhaSeleccionada', campanha);
            }
          });
        } else {
          controller.set('campanhaSeleccionada', response.objectAt(0));
        }
      });
    });


    self.store.find('tipoContacto', { by_activo: true, unpaged: true }).then(function(response) {
      controller.set('tipoContactos', response);
      response.forEach(function(tipoContacto) {
        if (tipoContacto.id === model._data.tipoContacto.id) {
          controller.set('tipoContactoSeleccionado', tipoContacto);
          console.log('tipoContacto',tipoContacto);
        }
      });
        console.log("tipoContactoSeleccionado",controller.get('tipoContactoSeleccionado'));
        if(controller.get('tipoContactoSeleccionado')){
          controller.set('isNotCampanha', !(tipoContactoSeleccionado.get('conCampanha') || tipoContactoSeleccionado.get('conMision')));
        }
        if(!controller.get('isNotCampanha')){
          var campanhas = null;
          if (tipoContactoSeleccionado.get('conCampanha') && tipoContactoSeleccionado.get('conMision')) {
            campanhas = self.store.find('campanha');
          }else {
            if(tipoContactoSeleccionado.get('conCampanha')){
              campanhas = self.store.find('campanha', { 'by_tipo_campanha': "Campaña"});
            }else if (tipoContactoSeleccionado.get('conMision')) {
              campanhas = self.store.find('campanha', { 'by_tipo_mision': true});
            }
          }

          campanhas.then(function(response) {
            if (model._data.campanha) {
              response.forEach(function(campanha) {
                if (campanha.id === model._data.campanha.id) {
                  controller.set('campanhaSeleccionada', campanha);
                }
              });
            } else {
              controller.set('campanhaSeleccionada', response.objectAt(0));
            }
          });
        }

    });
  }
});

Bodega.ContactoDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('contacto');
  },

  renderTemplate: function() {
    this.render('contactos.delete', {
      controller: 'contactoDelete'
    });
  }
});

Bodega.ContactosNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.createRecord('contacto');
  },

  renderTemplate: function() {
    this.render('contactos.new', {
      controller: 'contactosNew'
    });
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    var self = this;
    controller.set('estados',['Primer Contacto','Volver a llamar','Comprometido','Comprometido In Kind','Recibido','Recibido In Kind','Finalizado']);
    controller.set('estadoSeleccionado','Primer Contacto');

    this.store.find('moneda', { 'by_activo': true }).then(function(response) {
      controller.set('monedas', response);
      controller.set('monedaSeleccionada',response.objectAt(0));
      controller.set('monedaDefault',response.objectAt(0));
    });
    // controller.set('mostrarMoneda',true);
    controller.set('isNotCampanha',true);
    
    var detalles = model.get('contactoDetalles');
    console.log('Detalles: ', detalles);
    detalles.then(function(response){
      console.log("Seteando Detalles: ", response);
      controller.set('detalles', response);

    });

    var parametroMultimoneda = this.store.find('parametrosEmpresa', { 'by_soporta_multimoneda': true, 'unpaged': true });
    parametroMultimoneda.then(function() {
      if (parametroMultimoneda.objectAt(0)) {
        console.log("Seteando multimoneda...");
        controller.set('soportaMultimoneda', true);
      }else {
        controller.set('soportaMultimoneda', false);
      }
    });

    this.store.find('tipoContacto', { by_activo: true, unpaged: true }).then(function(response) {
      controller.set('tipoContactos', response);
    });
  }
});
