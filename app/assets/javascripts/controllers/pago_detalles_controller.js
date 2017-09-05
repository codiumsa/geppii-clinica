Bodega.VentaDetallesNewController = Ember.ObjectController.extend({
  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      model.save().then(function(response) {},
        function(response){
        // error
      });
    },

    cancel: function() {
      var model = this.get('model');
      this.transitionToRoute('pagos');
    }
  }
});