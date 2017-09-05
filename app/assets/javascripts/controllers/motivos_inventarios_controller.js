Bodega.MotivosInventarioIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable,
  Bodega.mixins.Filterable, {
    resource:  'inventario'
});

Bodega.MotivosInventariosBaseController = Ember.ObjectController.extend({
  needs: ['application'],




  actions: {




    cancel: function() {
      this.transitionToRoute('motivosInventarios');
    },

    save: function() {
      var model = this.get('model');
      var self = this;

      Bodega.Utils.disableElement('button[type=submit]');
        if (model.get('isValid'))
        {
          model.save().then(function(response) {
            Bodega.Utils.enableElement('button[type=submit]');
            //guardar los detalles
            self.transitionToRoute('motivosInventarios');
            if(self.get('edit')){
              Bodega.Notification.show('Éxito', 'El motivo de ajuste de Inventario se ha actualizado.');
            }else{
              Bodega.Notification.show('Éxito', 'El motivo de ajuste de Inventario se ha guardado.');
            }
          }, function(response) {
            //error
            Bodega.Utils.enableElement('button[type=submit]');
          });
        } else {
          Bodega.Utils.enableElement('button[type=submit]');
        }

    }

  }
});
//********************************************************************************************
Bodega.MotivosInventarioEditController = Bodega.MotivosInventariosBaseController.extend({

  formTitle: 'Editar Motivo de Ajuste de Inventario',
  //habilitarEdicionDetalle : true,

});

//********************************************************************************************
Bodega.MotivosInventariosNewController = Bodega.MotivosInventariosBaseController.extend({

  formTitle: 'Nuevo Motivo de Ajuste de Inventario',
  //habilitarEdicionDetalle : true,

});
//********************************************************************************************
Bodega.MotivosInventarioDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
      $('body').removeClass('modal-open');
      var self = this;
      var model = this.get('model');
      model.destroyRecord().then(function(response) {
        self.transitionToRoute('motivosInventarios');
        Bodega.Notification.show('Éxito', 'El Motivo de Ajuste de Inventario se ha eliminado.');
      }, function(response){
        self.transitionToRoute('motivosInventarios');
      });

    },

    cancel: function() {
      $('body').removeClass('modal-open');
      this.transitionToRoute('motivosInventarios');
    }
  }
});
