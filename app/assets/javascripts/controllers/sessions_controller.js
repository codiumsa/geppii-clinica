Ember.SimpleAuth.Authenticators.OAuth2.reopen({
  authenticate: function(credentials) {
        var _this = this;
        return new Ember.RSVP.Promise(function(resolve, reject) {
            var data;
            if(credentials.cajaImpresion) {
                data = { grant_type: 'password', username: credentials.identification, password: credentials.password, sucursal: credentials.sucursal, cajaImpresion: credentials.cajaImpresion};
            }
            else 
            {
                data = { grant_type: 'password', username: credentials.identification, password: credentials.password, sucursal: credentials.sucursal};
            }
          
          _this.makeRequest(data).then(function(response) {
            Ember.run(function() {
              var expiresAt = _this.absolutizeExpirationTime(response.expires_in);
              _this.scheduleAccessTokenRefresh(response.expires_in, expiresAt, response.refresh_token);
              resolve(Ember.$.extend(response, { expires_at: expiresAt }));
            });
            Script();
          }, function(xhr, status, error) {
            Ember.run(function() {
              reject(xhr.responseJSON || xhr.responseText);
            });
          });
        });
      }

 });


Bodega.SessionsNewController = Ember.Controller.extend(Ember.SimpleAuth.LoginControllerMixin, {
  formTitle: 'Iniciar Sesión',
  authenticatorFactory: 'authenticator:oauth2-password-grant',

  actions: {
    authenticate: function() {
      var credentials = this.getProperties('identification', 'password');

      var sucursal = this.get('sucursalDefault');
      console.log('SessionNewController');
      console.log(sucursal);
      var cajaImpresion;
        
    
      if(this.get('parametros')) {
        if(this.get('cajaImpresionSeleccionada')) {
            cajaImpresion = this.get('cajaImpresionSeleccionada'); 
        }
        else {
            cajaImpresion = this.get('cajaImpresionDefault');
        }
        
        if(cajaImpresion) {
            credentials.cajaImpresion = cajaImpresion.get('id');
        }
      }
      
        
      this.set('password', null);
      credentials.sucursal = sucursal.get('id');
      
      this.get('session').authenticate(this.get('authenticatorFactory'), credentials);
    }
  }

});