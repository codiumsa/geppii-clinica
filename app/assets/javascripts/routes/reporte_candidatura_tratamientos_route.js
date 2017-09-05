Bodega.ReporteCandidaturaTratamientosIndexRoute = Bodega.AuthenticatedRoute.extend({
  setupController: function(controller, model) {

	// this.store.find('campanha').then(function(response){
  //     controller.set('campanhas', response);
  //   });
      //
      //  controller.set('descripcion', null);
      // controller.set('productoSeleccionado', null);
      controller.set('incluyeDetalle', false);
      var medianteOptions = [{
        id:'Misión',
        descripcion:'Misión'
      }, {
        id:'Clínica',
        descripcion:'Clínica'
      }];
      controller.set('medianteOptions', medianteOptions);
      controller.set('medianteDefault', medianteOptions[0]);
      this.store.find('campanha', {'by_tipo_mision': true}).then(function(response){
        controller.set('campanhas', response);
        controller.set('campanhaDefault', response.objectAt[0]);
      });

  }
});

Bodega.ReporteCandidaturaTratamientos= Bodega.AuthenticatedRoute.extend({});
