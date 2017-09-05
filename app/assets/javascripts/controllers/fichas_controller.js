Bodega.FichasIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable,
  Bodega.mixins.Filterable,{
    perPage:  5,
    // resource:  'loteDeposito',
    queryParams: ['paciente_id','especialidad'],
    factory: 'fichas',
    resource: 'ficha',
    actions:{
      transitionEdit: function(fichaTemp){
        especialidad = this.get('especialidad');
        paciente = this.get('paciente');
        console.log(paciente);
        console.log(fichaTemp);
        console.log(especialidad);

        window.localStorage.setItem("origenFicha", 'indexFichas');
        var upEspecialidad = especialidad[0].toUpperCase() + especialidad.substr(1, especialidad.length);
        var self = this;

        console.log('ficha'+upEspecialidad);
        var ficha = self.store.find('ficha'+upEspecialidad, fichaTemp.id);

        ficha.then(function(response){
          response.reload().then(function(){
            console.log("ficha",response);
            var consulta = self.store.find('consulta', { 'by_nro_ficha': response.get('nroFicha') });
            consulta.then(function () {
              console.log('consulta.content.content.length',consulta.content.content.length);
              if (consulta.content.content.length > 0) {
                consultaTemp = consulta.objectAt(0);
                self.transitionToRoute('ficha' + upEspecialidad + '.edit', response, {
                  queryParams: {
                    paciente_id: paciente,
                    consulta_id: consultaTemp.id
                  }
                });

              } else {
                self.transitionToRoute('ficha' + upEspecialidad + '.edit', response, {
                  queryParams: {
                    paciente_id: paciente
                  }
                });
              }

            });
          });

        });








        // this.transitionToRoute(linkEspecialidad, ficha,{});
      }
    }

});
