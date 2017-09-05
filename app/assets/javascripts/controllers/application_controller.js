Bodega.ApplicationController = Ember.Controller.extend({
  //currentUser: function() {
  //return Bodega.AuthManager.get('apiKey.usuario')
  //}.property('Bodega.AuthManager.apiKey'),

  isNotAuthenticated: Ember.computed.not('session.isAuthenticated'),

  containerHeight: 600,

  containerHeightStyle: function() {
    return "height: " + this.get('containerHeight') + "px";
  }.property('containerHeight'),

  actions: {
    transitionTipoVenta: function(tipoVenta) {
      console.log('Transition a ventas: ' + tipoVenta);
      this.transitionToRoute('ventas', {
        queryParams: {
          tipoSalida: tipoVenta
        }
      });
    },
    editProfile: function() {
      var self = this;
      console.log('Transition a usuarios: ' + this.get('session').get('username'));
      var usuario = this.store.find('usuario', { by_username: this.get('session').get('username') });
      usuario.then(function(response) {
        self.transitionToRoute('usuario' + '.edit', response.objectAt(0));
      });
    }
  }
});