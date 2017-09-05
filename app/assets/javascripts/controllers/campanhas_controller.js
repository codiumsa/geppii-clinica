Bodega.CampanhasIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable,
  Bodega.mixins.Filterable, {
    resource: 'campanha',
    perPage: 9
  });

var estados = [{nombre: "Iniciada", id: "Iniciada"},
                {nombre: "Finalizada", id: "Finalizada"}];

Bodega.CampanhaBaseController = Ember.ObjectController.extend({


});


Bodega.CampanhasNewController = Bodega.CampanhaBaseController.extend({

  formTitle: 'Nueva Campaña',
	estados: estados,
  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      Bodega.Utils.disableElement('button[type=submit]');

      var tipoCampanha = this.get('tipoCampanhaSeleccionado');
      model.set('tipoCampanha', tipoCampanha);
			console.log(tipoCampanha);
			var estadoSeleccionado = this.get('estadoSeleccionado');
      model.set('estado', estadoSeleccionado.nombre);

      if (model.get('isValid')) {
        model.save().then(function(response) {

          // success
          self.transitionToRoute('campanhas').then(function() {
            Bodega.Notification.show('Exito', 'La campaña se ha guardado.');
            Bodega.Utils.enableElement('button[type=submit]');
            self.set('feedback', {});
          });

        }, function(response) {
          // error
          self.set('feedback', response.errors);
          Bodega.Utils.enableElement('button[type=submit]');
        });
      } else {
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },

    cancel: function() {
      var model = this.get('model');
      this.transitionToRoute('campanhas');
    }
  }
});

Bodega.CampanhaEditController = Bodega.CampanhaBaseController.extend({

  formTitle: 'Editar Campaña',
	estados: estados,

  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      Bodega.Utils.disableElement('button[type=submit]');
			var tipoCampanha = this.get('tipoCampanhaSeleccionado');
      model.set('tipoCampanha', tipoCampanha);
			console.log(tipoCampanha);
			var estadoSeleccionado = this.get('estadoSeleccionado');
      model.set('estado', estadoSeleccionado.nombre);


      if (model.get('isValid')) {
        model.save().then(function(response) {
          // success
          self.transitionToRoute('campanhas').then(function() {
            Bodega.Notification.show('Exito', 'La campaña se ha actualizado.');
            Bodega.Utils.enableElement('button[type=submit]');
          });
        }, function(response) {
          //error
          Bodega.Utils.enableElement('button[type=submit]');
        });
      } else {
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },

    cancel: function() {
      this.transitionToRoute('campanhas');
    }
  }
});

Bodega.CampanhaDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        Bodega.Notification.show('Exito', 'La campaña se ha eliminado.');
        self.transitionToRoute('campanhas');
      });
    },

    cancel: function() {
      $('body').removeClass('modal-open');
      this.transitionToRoute('campanhas');
    }
  }
});