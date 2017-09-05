Bodega.CursosIndexController = Ember.ArrayController.extend(Bodega.mixins.Pageable, Bodega.mixins.Filterable,{
  resource:  'curso',
  perPage:  15,
});



Bodega.CursosBaseController = Ember.ObjectController.extend({

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
          self.transitionToRoute('cursos');
          Bodega.Notification.show('Éxito', 'El curso se ha guardado.');
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
      var detalle = this.store.createRecord('cursoColaborador');
      var self = this;
      var cursoColaboradores = this.get('colaboradores');
      var observacion = this.get('observacion');
      if (cursoColaboradores) {
        cantidadcursos = cursoColaboradores.content.length;
      } else {

        console.log("No existen los campanhas!!");
        return;
      }
      if(colaborador){
        this.set('agregandoDetalle', true);
        if(observacion){
          detalle.set('observacion',observacion);
        }
        detalle.set('colaborador', colaborador);
        cursoColaboradores.addRecord(detalle);
        console.log(cursoColaboradores);
        this.set('agregandoDetalle', false);
        this.send('clearCurso');
        //console.log('Campanha agregada, lista: ', this.get('campanhas'));
        $("#curso").focus();
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
      $("#curso").focus();
    },

    clearCurso: function() {
      //console.log("ColaboradoressBaseController->clearCampanha: " + !this.get('agregandoDetalle'));
      if (!this.get('agregandoDetalle')) {
        this.set('descripcionSW', null);
        this.set('observacion',null);
        this.set('colaboradorSeleccionado', null);
      }
    }.observes('colaborador'),


    cancel: function() {
      var model = this.get('model');
      this.transitionToRoute('cursos');
    }
  }

});

//******************************ProductoNew****************************************************
Bodega.CursosNewController = Bodega.CursosBaseController.extend({
  formTitle: 'Nuevo Curso',
});

//***********************************************************************************************
Bodega.CursoEditController = Bodega.CursosBaseController.extend({

  formTitle: 'Editar Curso',

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
          self.transitionToRoute('cursos');
          Bodega.Notification.show('Éxito', 'El curso se ha actualizado.');
          Bodega.Utils.enableElement('button[type=submit]');
        }, function(response) {
          Bodega.Utils.enableElement('button[type=submit]');
        });
      }else{
        Bodega.Utils.enableElement('button[type=submit]');
      }
    },

    cancel: function() {
      this.transitionToRoute('cursos');
    }
  }

});


//***********************************************************************************************
Bodega.CursoDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
			$('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        self.transitionToRoute('cursos');
        Bodega.Notification.show('Éxito', 'El curso se ha eliminado.');

      }, function(){
        Bodega.Notification.show('Error', 'No se pudo eliminar el curso', Bodega.Notification.ERROR_MSG);
      });
    },

    cancel: function() {
			$('body').removeClass('modal-open');
      this.transitionToRoute('cursos');
    }
  }
});
