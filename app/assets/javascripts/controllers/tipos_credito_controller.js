Bodega.TipoCreditosIndexController = Ember.ArrayController.extend(Bodega.mixins.Pageable, 
  Bodega.mixins.Filterable,  {
  resource: 'tipoCredito'
});

var unidadesTiempo = [{nombre: "Días", id: "D"},
                {nombre: "Semanas", id: "W"},
                {nombre: "Meses", id: "M"},
                {nombre: "Meses (primera cuota en 1 mes)", id: "M+1"},
                {nombre: "Meses (primera cuota en 2 meses)", id: "M+2"},
                {nombre: "Meses (primera cuota en 3 meses)", id: "M+3"}];

Bodega.TipoCreditosNewController = Ember.ObjectController.extend({
  
  formTitle: 'Nuevo Tipo de Crédito',

  unidadesTiempo: unidadesTiempo,
  unidadDefault: {nombre: "Días", id: "D"},


  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
			Bodega.Utils.disableElement('button[type=submit]');
      
      var unidad = this.get('unidadTiempoSeleccionada');
      model.set('unidadTiempo', unidad.id);

      model.save().then(function(response) {
        // success
        self.transitionToRoute('tipoCreditos').then(function () {
          Bodega.Notification.show('Exito', 'El tipo crédito se ha creado.');
          Bodega.Utils.enableElement('button[type=submit]');
        });
      }, function(response){
        // error
				Bodega.Notification.show('Error', 'No se pudo crear el tipo crédito.', Bodega.Notification.ERROR_MSG);
        Bodega.Utils.enableElement('button[type=submit]');
      });
    },

    cancel: function() {
      this.transitionToRoute('tipoCreditos');
    }
  }
});

Bodega.TipoCreditoEditController = Ember.ObjectController.extend({

  formTitle: 'Editar Tipo Crédito',

  unidadesTiempo: unidadesTiempo,
  
  actions: {
    save: function() {
      var model = this.get('model');    
      var self = this;

      var unidad = this.get('unidadTiempoSeleccionada');
      model.set('unidadTiempo', unidad.id);
			Bodega.Utils.disableElement('button[type=submit]');

      model.save().then(function(response) {
        //success
        self.transitionToRoute('tipoCreditos').then(function () {
          Bodega.Notification.show('Exito', 'El tipo crédito se ha actualizado.');
          Bodega.Utils.enableElement('button[type=submit]');
        });
      }, function(response) {
        //error
				Bodega.Notification.show('Error', 'No se pudo actualizar el tipo crédito.', Bodega.Notification.ERROR_MSG);
        Bodega.Utils.enableElement('button[type=submit]');
      });
    },

    cancel: function() {
			
      this.transitionToRoute('tipoCreditos');
    }
  }
});

Bodega.TipoCreditoDeleteController = Ember.ObjectController.extend({
  actions: {
    deleteRecord: function() {
			$('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
			Bodega.Utils.disableElement('button[type=submit]');
      model.save().then(function() {
        self.transitionToRoute('tipoCreditos').then(function () {
          Bodega.Notification.show('Exito', 'El tipo crédito se ha eliminado.');
          Bodega.Utils.enableElement('button[type=submit]');
        });
      }, function(response) {

				Bodega.Notification.show('Error', 'No se pudo borrar el tipo crédito.', Bodega.Notification.ERROR_MSG);
        Bodega.Utils.enableElement('button[type=submit]');
      });
    },

    cancel: function() {
			$('body').removeClass('modal-open');
      this.transitionToRoute('tipoCreditos');
    }
  }
});