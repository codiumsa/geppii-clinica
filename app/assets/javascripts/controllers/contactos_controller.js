Bodega.ContactosIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable,
  Bodega.mixins.Filterable, {
    resource: 'contacto'
  });

Bodega.ContactoBaseController = Ember.ObjectController.extend({

  formTitle: 'Editar Contacto con Sponsor',

  loading: false,

  loadingCuota: false,

  // estadoSeleccionadoObserver: function (){
  //   var estadoSeleccionado = this.get('estadoSeleccionado');
  //   if (estadoSeleccionado && (estadoSeleccionado == 'Comprometido In Kind' ||  estadoSeleccionado == 'Recibido In Kind')) {
  //     this.set('mostrarMoneda',true);
  //     this.set('monedaSeleccionada', null);
  //   }else {
  //     this.set('mostrarMoneda',false);
  //     this.set('monedaSeleccionada',this.get('monedaDefault'));
  //   }
  // }.observes('estadoSeleccionado'),

  loadSponsor: function() {
    var ruc = this.get('ciRuc');
    var self = this;
    var model = self.get('model');
    var loading = self.get('loading');
    var sponsorSeleccionadoText = this.get('sponsorSeleccionadoText');
    console.log('sponsorSeleccionadoText',sponsorSeleccionadoText);

    var sponsorActual = model.get('sponsor');

    var sponsor = this.get('sponsorSeleccionado');
    console.log('sponsor',sponsor);
    var tipoContactos = this.get('tipoContactos');
    if (sponsor != null && tipoContactos) {
      if (sponsorSeleccionadoText != ''){
        self.set('sponsorActual', sponsor);
        model.set('sponsor', sponsor);
        tipoContactoSeleccionado = self.get('tipoContactoSeleccionado');
        if (!tipoContactoSeleccionado){
          self.set('tipoContactoSeleccionado', self.get('tipoContactos').objectAt(0));
        }
        if(tipoContactoSeleccionado){
          self.set('isNotCampanha', !(tipoContactoSeleccionado.get('conCampanha') || tipoContactoSeleccionado.get('conMision')));
        }
        if(!self.get('isNotCampanha')){
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
            self.set('campanhas', response);
            self.set('campanhaSeleccionada', response.objectAt(0));
          });
        }
      }else{
        model.set('sponsor', null);
        self.set('sponsorSeleccionado', null);
        self.set('tipoContactoSeleccionado', null);
        console.log('legaaaaa');
      }
    } else {
      if (sponsorActual) {
        model.set('sponsor', null);
        self.set('sponsorActual', null);
        self.set('tipoContactoSeleccionado', null);
      }
    }

  }.observes('sponsorSeleccionado', 'tipoContactoSeleccionado', 'sponsorSeleccionadoText'),

  // loadSponsor: function() {
  //   var ruc = this.get('ciRuc');
  //   var self = this;
  //   var model = self.get('model');
  //   var loading = self.get('loading');

  //   var sponsorActual = model.get('sponsor');

  //   if (ruc && !loading) {
  //     var sponsors = this.store.find('sponsor', {
  //       'by_ciRuc': ruc
  //     });

  //     sponsors.then(function() {
  //       var sponsor = sponsors.objectAt(0);

  //       if (sponsor) {
  //         self.set('sponsorActual', sponsor);
  //         model.set('sponsor', sponsor);
  //         tipoContactoSeleccionado = self.get('tipoContactoSeleccionado');
  //         if (!tipoContactoSeleccionado){
  //           self.set('tipoContactoSeleccionado', self.get('tipoContactos').objectAt(0));
  //         }
  //         if(tipoContactoSeleccionado){
  //           self.set('isNotCampanha', !(tipoContactoSeleccionado.get('conCampanha') || tipoContactoSeleccionado.get('conMision')));
  //         }

  //         var campanhas = null;
  //         campanhas = self.store.find('campanha', { 'by_tipo_contacto': self.get('tipoContactoSeleccionado').get('id'), 'by_vigente': true });

  //         campanhas.then(function(response) {
  //           console.log("Campanhas:", campanhas);
  //           self.set('campanhas', response);
  //           self.set('campanhaSeleccionada', response.objectAt(0));
  //         });


  //       } else {
  //         if (sponsorActual) {
  //           model.set('sponsor', null);
  //           self.set('sponsorActual', null);
  //           self.set('tipoContactoSeleccionado', null);
  //         }
  //       }
  //     });
  //   } else if (loading) {
  //     this.set('loading', false);
  //   } else {
  //     if (sponsorActual) {
  //       model.set('sponsor', null);
  //       self.set('sponsorActual', null);
  //       self.set('tipoContactoSeleccionado', null);
  //     }
  //   }
  // }.observes('ciRuc', 'tipoContactoSeleccionado'),

  actions: {

    agregarDetalle: function(){
      var detalle = this.store.createRecord('contactoDetalle');
      var detalles = this.get('detalles');
      console.log('detalles',detalles);
      detalle.set('fecha',this.get('fechaDetalle'));
      detalle.set('fechaSiguiente',this.get('fechaSiguienteDetalle'));
      detalle.set('comentario',this.get('comentarioDetalle'));
      detalle.set('estado',this.get('estadoSeleccionado'));
      detalle.set('compromiso',this.get('compromisoDetalle'));
      detalle.set('moneda',this.get('monedaSeleccionada'));
      detalle.set('observacion',this.get('observacionDetalle'));
      this.set('agregandoDetalle', true);
      detalles.addRecord(detalle);
      console.log("Detalle agregado: ", detalle);
      this.set('agregandoDetalle', false);
      this.send('clearDetalle');
    },

    clearDetalle: function(){
      this.set('comentarioDetalle',null);
      this.set('compromisoDetalle',null);
      this.set('observacionDetalle',null);
      this.set('estadoDetalle',null);
      this.set('monedaSeleccionada',this.get('monedas').objectAt(0));
      this.set('fechaDetalle',moment().toDate());
      this.set('fechaSiguienteDetalle',moment().toDate());
      this.set('estadoSeleccionado','Primer Contacto');
    },

    borrarDetalle: function(detalle){
      console.log('detalle: ',detalle);
      console.log('detalles: ',this.get('detalles'));
      this.get('detalles').removeRecord(detalle);
    },

    save: function() {
      var model = this.get('model');
      var self = this;
      var tipoContactoSeleccionado = this.get('tipoContactoSeleccionado');
      var errors = model.get('errors');

      console.log('sponsor',model.get('sponsor'));
      if(!model.get('id')) {
        if(this.get('sponsorSeleccionado') == null){
          Bodega.Notification.show('Error', 'Ingrese un Patrocinador', Bodega.Notification.ERROR_MSG);
          return;
        }
        if (tipoContactoSeleccionado) {
          model.set('tipoContacto', tipoContactoSeleccionado);
          if (tipoContactoSeleccionado.get('conCampanha') || tipoContactoSeleccionado.get('conMision')) {
            model.set('campanha', this.get('campanhaSeleccionada'));
          } else {
            model.set('campanha', null);
          }
        }
      }


      if (model.get('isValid')) {
        Bodega.Utils.disableElement('.btn');
        model.save().then(function(response) {
          //success
          self.transitionToRoute('contactos').then(function() {
            Bodega.Notification.show('Éxito', 'Contacto con Sponsor Guardado');
            Bodega.Utils.enableElement('.btn');
          });
        }, function(response) {
          //error
          Bodega.Utils.enableElement('.btn');
        });
      }
    },

    cancel: function() {
      this.transitionToRoute('contactos');
    }
  }
});

Bodega.ContactosNewController = Bodega.ContactoBaseController.extend({

  formTitle: 'Nuevo Contacto con Sponsor'
});

Bodega.ContactoEditController = Bodega.ContactoBaseController.extend({

  formTitle: 'Editar Contacto con Sponsor',
  actions:{
    borrarDetalle: function(detalle){
      console.log('detalle: ',detalle);
      console.log('detalles: ',this.get('detalles'));
      this.get('detalles').content.removeRecord(detalle);
    },
    agregarDetalle: function(){
      var detalle = this.store.createRecord('contactoDetalle');
      var detalles = this.get('detalles').content;
      console.log('detalles',detalles);
      detalle.set('fecha',this.get('fechaDetalle'));
      detalle.set('fechaSiguiente',this.get('fechaSiguienteDetalle'));
      detalle.set('comentario',this.get('comentarioDetalle'));
      detalle.set('estado',this.get('estadoSeleccionado'));
      detalle.set('compromiso',this.get('compromisoDetalle'));
      detalle.set('moneda',this.get('monedaSeleccionada'));
      detalle.set('observacion',this.get('observacionDetalle'));
      this.set('agregandoDetalle', true);
      detalles.addRecord(detalle);
      console.log("Detalle agregado: ", detalle);
      this.set('agregandoDetalle', false);
      this.send('clearDetalle');
    }
  }
});

Bodega.ContactoDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        self.transitionToRoute('contactos');
      });
    },

    cancel: function() {
      $('body').removeClass('modal-open');
      this.transitionToRoute('contactos');
    }
  }
});
