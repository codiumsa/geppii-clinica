Bodega.FichasPsicologiaBaseController = Bodega.ClinicaBaseController.extend({
  queryParams: ['paciente_id', 'consulta_id'],
  paciente_id: null,
  consulta_id: null,

  actions: {
    save: function() {
      var self = this;
      var model = this.get('model');
      var listaTratamientos = this.get('listaTratamientos');
      model.set('paciente', this.get('pacienteActual'));
      model.set('consultaId', this.get('consulta_id'));
      Bodega.Utils.disableElement('button[type=submit]');
      if (model.get('isValid')) {
        model.save()
          .then(function(response) {
            // success
            self.store.find('paciente', { id: self.get('paciente_id') }).then(function(response) {
              if (self.get('consulta_id')) {
                self.transitionToRoute('consulta.edit', self.get('consulta_id')).then(function() {
                  Bodega.Notification.show('Éxito', 'La ficha de psicología se ha modificado.');
                  Bodega.Utils.enableElement('button[type=submit]');
                });
              } else {
                self.transitionToRoute('paciente.edit', response.objectAt(0)).then(function() {
                  Bodega.Notification.show('Éxito', 'La ficha de psicología se ha creado.');
                  Bodega.Utils.enableElement('button[type=submit]');
                });
              }
            });
          }, function(response) {
            console.log('ERROR: ', response);
            Bodega.Notification.show('Error', 'La ficha de psicología no se pudo crear', 'error');
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
      //this.transitionToRoute('fichas_odontologia');
    }
  }
});

Bodega.FichasPsicologiaNewController = Bodega.FichasPsicologiaBaseController.extend({
  self: this,
  queryParams: ['paciente_id'],
  paciente_id: null,
  formTitle: 'Nueva Ficha Psicología',
  listaTratamientos: [],

});

Bodega.FichaPsicologiaEditController = Bodega.FichasPsicologiaBaseController.extend({
  self: this,
  queryParams: ['paciente_id'],
  paciente_id: null,
  formTitle: 'Nueva Ficha Psicología',
  listaTratamientos: [],

});