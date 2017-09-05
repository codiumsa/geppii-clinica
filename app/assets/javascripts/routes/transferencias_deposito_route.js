Bodega.TransferenciaDepositoRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.TransferenciasDepositoIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('transferenciaDeposito', {page: 1});
  },
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);

    this.store.find('deposito').then(function(response){
      controller.set('depositos', response);
    });
  }
});

Bodega.TransferenciaDepositoEditRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('transferenciaDeposito');
  },

  renderTemplate: function() {
    this.render('transferenciasDeposito.new', {
      controller: 'transferenciaDepositoEdit'
    });
  },

  setupController: function(controller, model) {
      controller.set('model', model);
      controller.set('edit', true);

      model.get('detalle').then(function(response){
        controller.set('detalles', response);
      });
      controller.set('detNuevo', this.store.createRecord('transferenciaDepositoDetalle'));

      var parametrosImprimeRemision = this.store.find('parametrosEmpresa', {'by_imprimir_remision': true, 'unpaged': true});
      parametrosImprimeRemision.then(function() {
      var parametro = parametrosImprimeRemision.objectAt(0);

      if(parametro){
          controller.set('soportaImprimirRemision', true);
      }
      else{
          controller.set('soportaImprimirRemision', false);
      }
  });
    }


});


Bodega.TransferenciaDepositoDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function(params) {
    return this.modelFor('transferenciaDeposito');
  },

  renderTemplate: function() {
    this.render('transferenciasDeposito.delete', {
      controller: 'transferenciaDepositoDelete'
    });
  }
});

Bodega.TransferenciasDepositoNewRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.createRecord('transferenciaDeposito');
  },

  setupController: function(controller, model) {
      var usuarios = this.store.find('usuario', {'username' : this.get('session').get('username')});
      usuarios.then(function(){
        model.set('usuario', usuarios.objectAt(0));
      });

      controller.set('model', model);
      controller.set('origenController',null);

      model.get('detalle').then(function(response){
        controller.set('detalles', response);
      });

      var parametrosImprimeRemision = this.store.find('parametrosEmpresa', {'by_imprimir_remision': true, 'unpaged': true});

        parametrosImprimeRemision.then(function() {

            var parametro = parametrosImprimeRemision.objectAt(0);
            if(parametro){
                controller.set('soportaImprimirRemision', true);
            }
            else{
                controller.set('soportaImprimirRemision', false);
            }
        });

      controller.set('detNuevo', this.store.createRecord('transferenciaDepositoDetalle'));
    }


});
