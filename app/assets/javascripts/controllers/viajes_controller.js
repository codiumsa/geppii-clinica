Bodega.ViajesIndexController = Ember.ArrayController.extend(Bodega.mixins.Pageable, Bodega.mixins.Filterable,{
  resource:  'viaje',
  perPage:  15,
});


Bodega.ViajesBaseController = Ember.ObjectController.extend({

  actions: {

    save: function() {
      var model = this.get('model');
      var self = this;

      var fechaInicio = this.get('fechaInicio');
      var fechaFin = this.get('fechaFin');
      if (fechaInicio && fechaFin && (fechaInicio.getTime()>fechaFin.getTime())) {
        Bodega.Notification.show('Error','Seleccione un rango de fechas válido',Bodega.Notification.ERROR_MSG);
        return;
      }
      // }else if (fechaInicio == undefined || fechaFin == undefined) {
      //   Bodega.Notification.show('Error','Seleccione un rango fechas',Bodega.Notification.ERROR_MSG);
      //   return;
      // }

      Bodega.Utils.disableElement('button[type=submit]');

      if(model.get('isValid')) {
        model.save().then(function(response) {
          // success
          self.transitionToRoute('viajes');
          Bodega.Notification.show('Éxito', 'El viaje se ha guardado.');
          Bodega.Utils.enableElement('button[type=submit]');
        }, function(response){
          Bodega.Utils.enableElement('button[type=submit]');
        });
      }else{
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },

    loadFromSearchWidget: function() {
      //console.log("ColaboradoresBaseController->loadFromSearchWidget");
      if (!this.get('agregandoDetalle')) {
        //console.log("ColaboradoresBaseController->loadFromSearchWidget agregandoDetalle false");
        var colaboradorSeleccionado = this.get('colaboradorSeleccionado');
        //console.log(campanhaSeleccionada);
        if (colaboradorSeleccionado && colaboradorSeleccionado.get('id') !== null) {
          this.loadColaborador();
        }
      }
    }.observes('campanhaSeleccionadaSW'),

    agregarDetalle: function() {
      console.log("Agregando detalle");
      var colaborador = this.get('colaboradorSeleccionado');
      var detalle = this.store.createRecord('viajeColaborador');
      var self = this;
      var viajeColaboradores = this.get('colaboradores');
      var observacion = this.get('observacion');
      var companhia = this.get('companhia');
      var costoTicket = this.get('costoTicket');
      var costoEstadia = this.get('costoEstadia');


      if (viajeColaboradores) {
        cantidadviajes = viajeColaboradores.content.length;
      } else {
        console.log("No existen los viajes!!");
        return;
      }
      if(colaborador){
        this.set('agregandoDetalle', true);
        if(observacion){
          detalle.set('observacion',observacion);
        }
        if(companhia){
          detalle.set('companhia',companhia);
        }
        if(costoEstadia){
          detalle.set('costoEstadia',costoEstadia);
        }
        if(costoTicket){
          detalle.set('costoTicket',costoTicket);
        }
        detalle.set('colaborador', colaborador);
        viajeColaboradores.addRecord(detalle);
        console.log(viajeColaboradores);
        this.set('agregandoDetalle', false);
        this.send('clearViaje');
        //console.log('Campanha agregada, lista: ', this.get('campanhas'));
        $("#viaje").focus();
        this.set('count', 0);
      }else{
        Bodega.Notification.show('Error', 'Debe elegir un colaborador para poder agregarlo', Bodega.Notification.ERROR_MSG);
        return;
      }

    },

    borrarColaborador: function(detalle){
      var self = this;

      this.get('colaboradores').removeRecord(detalle);
    },

    loadColaborador: function() {
      //console.log('ColaboradoresBaseController->loadcampanha');
      //console.log('campanhaSeleccionadaSW', this.get('campanhaSeleccionadaSW'));
      var model = this.get('model');
      var detalle = this.get('colaboradorNuevo');
      $("#viaje").focus();
    },

    clearViaje: function() {
      //console.log("ColaboradoressBaseController->clearCampanha: " + !this.get('agregandoDetalle'));
      if (!this.get('agregandoDetalle')) {
        this.set('descripcionSW', null);
        this.set('observacion',null);
        this.set('costoTicket',null);
        this.set('costoEstadia',null);
        this.set('companhia',null);
        this.set('colaboradorSeleccionado', null);
      }
    }.observes('colaborador'),


    cancel: function() {
      var model = this.get('model');
      this.transitionToRoute('viajes');
    }
  }

});

//******************************ProductoNew****************************************************
Bodega.ViajesNewController = Bodega.ViajesBaseController.extend({
  formTitle: 'Nuevo Viaje',
});

//***********************************************************************************************
Bodega.ViajeEditController = Bodega.ViajesBaseController.extend({

  formTitle: 'Editar Viaje',

  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      var fechaInicio = this.get('fechaInicio');
      var fechaFin = this.get('fechaFin');
      if (fechaInicio && fechaFin && (fechaInicio.getTime()>fechaFin.getTime())) {
        Bodega.Notification.show('Error','Seleccione un rango de fechas válido',Bodega.Notification.ERROR_MSG);
        return;
      }
      // }else if (fechaInicio == undefined || fechaFin == undefined) {
      //   Bodega.Notification.show('Error','Seleccione un rango fechas',Bodega.Notification.ERROR_MSG);
      //   return;
      // }
      Bodega.Utils.disableElement('button[type=submit]');

      if(model.get('isValid')) {
        model.save().then(function(response) {
          //success
          self.transitionToRoute('viajes');
          Bodega.Notification.show('Éxito', 'El viaje se ha actualizado.');
          Bodega.Utils.enableElement('button[type=submit]');
        }, function(response) {
          Bodega.Utils.enableElement('button[type=submit]');
        });
      }else{
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },

    cancel: function() {
      this.transitionToRoute('viajes');
    }
  }

});


//***********************************************************************************************
Bodega.ViajeDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
			$('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        self.transitionToRoute('viajes');
        Bodega.Notification.show('Éxito', 'El viaje se ha eliminado.');

      }, function(){
        Bodega.Notification.show('Error', 'No se pudo eliminar el viaje', Bodega.Notification.ERROR_MSG);
      });
    },

    cancel: function() {
			$('body').removeClass('modal-open');
      this.transitionToRoute('viajes');
    }
  }
});
