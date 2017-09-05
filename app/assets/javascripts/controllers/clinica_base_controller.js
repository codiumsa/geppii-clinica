Bodega.ClinicaBaseController =
  Ember.ObjectController.extend({
    needs: ['application'],
    formTitle: '',
    numeral: '#',
    imgMissing: '/images/missing_small.png',
    feedback: Ember.Object.create(),
    habilitaGuardar: {},


    getEspecialidadModelByCodigo: function(codigo) {
      if (codigo === 'ODO') return 'odontologia';
      if (codigo === 'NUT') return 'nutricion';
      if (codigo === 'CIR') return 'cirugia';
      if (codigo === 'PSI') return 'psicologia';
      if (codigo === 'FON') return 'fonoaudiologia';

    },

    actions: {
      detalleSiguiente:function(){
        var self = this;
        var posConsultaDetalle = this.get('posConsultaDetalle');
        var posConsultaDetalle = posConsultaDetalle + 1;
        var consultas = this.get('consultas');
        consultas.objectAt(posConsultaDetalle).get('consultaDetalles').then(function(consultaDetallesTemp){
          console.log('prueba',consultaDetallesTemp);
          self.set('consultaActual', consultas.objectAt(posConsultaDetalle));
          self.set('consultaDetallesActual',consultaDetallesTemp);
          self.set('posConsultaDetalle',posConsultaDetalle);
          self.set('mostrarAnterior',true);

          if (posConsultaDetalle < consultas.content.length - 1) {
            self.set('mostrarSiguiente',true);
          }else {
            self.set('mostrarSiguiente',false);
          }
        });


      },

      detalleAnterior:function(){
        var self = this;
        posConsultaDetalle = this.get('posConsultaDetalle');
        posConsultaDetalle = posConsultaDetalle - 1;
        consultas = this.get('consultas');

        consultas.objectAt(posConsultaDetalle).get('consultaDetalles').then(function(consultaDetallesTemp){
          self.set('consultaActual', consultas.objectAt(posConsultaDetalle));
          self.set('consultaDetallesActual',consultaDetallesTemp);
          self.set('posConsultaDetalle',posConsultaDetalle);
          self.set('mostrarSiguiente',true);
          if (posConsultaDetalle > 0) {
            self.set('mostrarAnterior',true);
          }else {
            self.set('mostrarAnterior',false);
          }
        });

      },

      agregarDetalle: function(fieldModel, newField) {
        console.log('ClinicaBaseController->agregarDetalle');
        var detalle = this.get(newField);
        console.log('DETALLE NUEVO', detalle);
        var agregar = true;
        if (agregar) {
          this.set(newField, this.getNewModel(newField));
          if (!this.get(fieldModel)) {
            this.set(fieldModel, []);
          }
          this.get(fieldModel).pushObject(detalle);
          //$("#fecha").focus();
        }
      },

      borrarDetalle: function(detalle, fieldModel, fieldController) {
        console.log(detalle);
        detalle.eliminado = true;
        this.get(fieldModel).slice();
        this.propertyDidChange(fieldController);
        console.log("ClinicaBaseController->borrarDetalle - Lista: ", this.get(fieldModel));
        this.get('controllers.application').set('containerHeighPt', Bodega.newHeightWrapper());
      },

      goEditFicha: function(pacienteId, consultaId, especialidad) {
        console.log('goEditFicha(', pacienteId, consultaId, especialidad, ');');
        console.log('consultaId',consultaId);
        var self = this;

        if(especialidad == null){
          especialidadNull = true;
          var consultaTemp = self.store.find('consulta', consultaId);
          consultaTemp.then(function(){
            var especialidadTemp = consultaTemp.get('especialidad');
            especialidadTemp.then(function () {
              especialidad = especialidadTemp.get('codigo');
              self.send('goEditFichaFinal',pacienteId,consultaId,especialidad);
            });
          });
        }else{
          self.send('goEditFichaFinal',pacienteId,consultaId,especialidad);
        }

      },

      goEditFichaFinal: function(pacienteId, consultaId, especialidad){
        var self = this;

        var nombreEspecialidad = this.getEspecialidadModelByCodigo(especialidad);
        if (nombreEspecialidad) {
          console.log('NOMBRE ESPECIALIDAD: ', nombreEspecialidad);
          especialidad = nombreEspecialidad;
        }
        var fichas = this.store.find('ficha_' + especialidad, { paciente_id: pacienteId });
        var ficha;
        window.localStorage.setItem("origenFicha", 'noIndexFichas');

        fichas.then(function(obj) {
          var upEspecialidad = especialidad[0].toUpperCase() + especialidad.substr(1, especialidad.length);
          console.log('consultaId',consultaId);
          if (fichas.content.content.length == 0 && consultaId == 0) {
            self.transitionToRoute('fichas' + upEspecialidad + '.new', {
              queryParams: {
                paciente_id: pacienteId
              }
            });
            return;
          }

          ficha = obj.objectAt(0);
          if(consultaId == 0){
            var consulta = self.store.find('consulta', { 'by_nro_ficha': ficha.get('nroFicha') });
            consulta.then(function () {
              console.log('consulta.content.content.length',consulta.content.content.length);
              if (consulta.content.content.length > 0) {
                consultaTemp = consulta.objectAt(0);
                if (ficha === undefined || ficha === null || ficha.get('id') === undefined) {
                  self.transitionToRoute('fichas' + upEspecialidad + '.new', {
                    queryParams: {
                      paciente_id: pacienteId,
                      consulta_id: consultaTemp.id
                    }
                  });
                } else {
                  self.transitionToRoute('ficha' + upEspecialidad + '.edit', ficha, {
                    queryParams: {
                      paciente_id: pacienteId,
                      consulta_id: consultaTemp.id
                    }
                  });
                }
              } else {
                if (ficha === undefined || ficha === null || ficha.get('id') === undefined) {
                  self.transitionToRoute('fichas' + upEspecialidad + '.new', {
                    queryParams: {
                      paciente_id: pacienteId
                    }
                  });
                } else {
                  self.transitionToRoute('ficha' + upEspecialidad + '.edit', ficha, {
                    queryParams: {
                      paciente_id: pacienteId
                    }
                  });
                }
              }

            });
          }else{
            if (ficha === undefined || ficha === null || ficha.get('id') === undefined) {
              self.transitionToRoute('fichas' + upEspecialidad + '.new', {
                queryParams: {
                  paciente_id: pacienteId,
                  consulta_id: consultaId
                }
              });
            } else {
              console.log('entraUltimoElse');
              self.transitionToRoute('ficha' + upEspecialidad + '.edit', ficha, {
                queryParams: {
                  paciente_id: pacienteId,
                  consulta_id: consultaId
                }
              });
            }
          }

        });
      },

      goNewFicha: function(pacienteId, consultaId, especialidad) {
        var self = this;
        var nombreEspecialidad = this.getEspecialidadModelByCodigo(especialidad);
        if (nombreEspecialidad) {
          especialidad = nombreEspecialidad;
        }
        var upEspecialidad = especialidad[0].toUpperCase() + especialidad.substr(1, especialidad.length);
        self.transitionToRoute('fichas' + upEspecialidad + '.new', {
          queryParams: {
            paciente_id: pacienteId,
            consulta_id: consultaId
          }
        });
      },
    }
  });
