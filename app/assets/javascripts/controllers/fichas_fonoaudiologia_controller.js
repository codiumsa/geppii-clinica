Bodega.FichasFonoaudiologiaBaseController = Bodega.ClinicaBaseController.extend({
  queryParams: ['paciente_id', 'consulta_id'],
  paciente_id: null,
  consulta_id: null,

  updateFistulaSVGData: function(data) {
    this.send('updateFistulaSVGData', data);
  },
  actions: {
    scrollToTop: function(top) {
      jQuery('html,body').animate({
          scrollTop: top
      }, 500); 
    },
    updateFistulaSVGData: function(data) {
      var fistula = this.get('fistula');
      fistula.svg = data;
      this.set('fistula', fistula);
    },
    mostrarOcultarSubEstimulos: function() {
      var self = this;
      var mostraSubestimulos = this.get('mostraSubestimulos');
      console.log(this);
      this.get('estimulos').forEach(function(estimulo) {
        if (estimulo.nombre == 'produccionDeConsonantes') {
          if (estimulo.valor !== null &&
            estimulo.valor === 'Errores del desarrollo fonológico/articulatorio') {
            self.set('mostraSubestimulos', true);
          } else {
            self.set('mostraSubestimulos', false);
          }
        }
      });
    },

    save: function() {
      var self = this;
      var model = this.get('model');
      //var self = this;
      Bodega.Utils.disableElement('button[type=submit]');
      if (model.get('isValid')) {
        //var fichaFonoaudiologia = this.store.createRecord('fichaFonoaudiologia');
        //model.set('paciente' , model.get('id'));
        model.set('comunicacionLenguaje', this.get('comunicacionEtapas'));
        model.set('estimulos', this.get('estimulos'));
        model.set('alimentacion', this.get('alimentacion'));
        model.set('fistula', this.get('fistula'));
        model.set('paciente', this.get('pacienteActual'));
        model.set('consultaId', this.get('consulta_id'));

        model.save()
          .then(function(response) {
            // success
            self.store.find('paciente', { id: self.get('paciente_id') }).then(function(response) {
              if (self.get('consulta_id')) {
                self.transitionToRoute('consulta.edit', self.get('consulta_id')).then(function() {
                  Bodega.Notification.show('Éxito', 'La ficha de fonoaudiología se ha modificado.');
                  Bodega.Utils.enableElement('button[type=submit]');
                });
              } else {
                self.transitionToRoute('paciente.edit', response.objectAt(0)).then(function() {
                  Bodega.Notification.show('Éxito', 'La ficha de fonoaudiología se ha creado.');
                  Bodega.Utils.enableElement('button[type=submit]');
                });
              }
            });
            // self.transitionToRoute('fichasFonoaudiologia').then(function() {
            //   Bodega.Notification.show('Éxito', 'La ficha de fonoaudiología se ha creado.');
            //   Bodega.Utils.enableElement('button[type=submit]');
            // });
          }, function(response) {
            console.log('ERROR: ', response);
            Bodega.Notification.show('Error', 'La ficha de fonoaudiología no se pudo crear', 'error');
            Bodega.Utils.enableElement('button[type=submit]');
            model.transitionTo('uncommitted');
            //model.rollback();
          });
      } else {
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },
    cancel: function() {
      var model = this.get('model');
      model.deleteRecord();
      this.transitionToRoute('fichas_fonoaudiologia');
    }
  }
});

Bodega.FichasFonoaudiologiaNewController = Bodega.FichasFonoaudiologiaBaseController.extend({
  self: this,
  queryParams: ['paciente_id'],
  paciente_id: null,
  formTitle: 'Nueva Ficha Fonoaudiologia',
  
});

Bodega.FichaFonoaudiologiaEditController = Bodega.FichasFonoaudiologiaBaseController.extend({
  formTitle: 'Editar FichaFonoaudiologia',
  self: this,
  // actions: {
  //   save: function() {
  //     var model = this.get('model');
  //     var self = this;
  //     Bodega.Utils.disableElement('button[type=submit]');
  //     model.set('comunicacionLenguaje', this.get('comunicacionEtapas'));
  //     model.set('estimulos', this.get('estimulos'));
  //     model.set('alimentacion', this.get('alimentacion'));
  //     model.set('fistula', this.get('fistula'));
  //     model.save().then(function(response) {
  //       //success
  //
  //       self.store.find('paciente', {id: self.get('paciente_id')}).then(function(response){
  //         self.transitionToRoute('paciente.edit',response.objectAt(0)).then(function() {
  //           Bodega.Notification.show('Éxito', 'La ficha de fonoaudiología se ha modificado.');
  //           Bodega.Utils.enableElement('button[type=submit]');
  //         });
  //       });
  //
  //       // Bodega.Notification.show('Éxito', 'La ficha de fonoaudiología se ha modificado.');
  //       // Bodega.Utils.enableElement('button[type=submit]');
  //       //self.transitionToRoute('fichasFonoaudiologia');
  //     }, function(response) {
  //       Bodega.Notification.show('Error', 'La ficha de fonoaudiología no se pudo crear', 'error');
  //       Bodega.Utils.enableElement('button[type=submit]');
  //       model.transitionTo('uncommitted');
  //       //model.rollback();
  //     });
  //   },
  //
  //   cancel: function() {
  //     this.transitionToRoute('fichas_fonoaudiologia');
  //   }
  // }
});

Bodega.FichaFonoaudiologiaDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
      $('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        Bodega.Notification.show('Éxito', 'La ficha de fonoaudiología se ha eliminado.');
        Bodega.Utils.enableElement('button[type=submit]');
        self.transitionToRoute('fichasFonoaudiologia');
      }, function(response) {
        //error
        Bodega.Notification.show('Éxito', 'La ficha de fonoaudiología se ha eliminado.', 'error');
        Bodega.Utils.enableElement('button[type=submit]');
        model.transitionTo('uncommitted');
      });
    },

    cancel: function() {
      $('body').removeClass('modal-open');
      this.transitionToRoute('fichas_fonoaudiologia');
    }
  }
});

Bodega.FichasFonoaudiologiaIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable, Bodega.mixins.Filterable, {
    resource: 'fichaFonoaudiologia'
  });