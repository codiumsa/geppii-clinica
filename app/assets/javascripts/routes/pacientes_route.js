Bodega.PacientesIndexRoute = Bodega.AuthenticatedRoute.extend({

  model: function () {
    return this.store.find('paciente', {
      page: 1
    });
  },

  setupController: function (controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.PacienteRoute = Bodega.AuthenticatedRoute.extend({});

Bodega.PacienteBaseRoute = Bodega.AuthenticatedRoute.extend({
  setupCommonProps: function (controller, model) {
    controller.set('model', model);
    controller.set('tipoPersonas', ['Física', 'Jurídica']);
    controller.set('jubiladoComercianteOpts', ['Jubilado', 'Comerciante']);
    controller.set('tiposReferencia', ['Comercial', 'Personal', 'Bancaria']);
    controller.set('estadoCivilOpts', ['Soltero/a', 'Casado/a', 'Divorciado/a', 'Viudo/a']);
    controller.set('perfilLaboral', '');
    controller.set('perfilesLaborales', ['Empleador', 'Jubilado', 'Comerciante']);
    controller.set('sexos', ['Masculino', 'Femenino']);
    controller.set('estudiosRealizados', ['Primario', 'Secundario', 'Terciario']);
    controller.set('fuentesOpSonrisa', ['TV', 'Radio', 'Hospital', 'Redes Sociales', 'Familiares', 'Amigos', 'Otros']);
    controller.set('tiposDomicilios', ['Propia', 'Alquilada', 'Familiar']);
    controller.set('cirugiaNueva', Ember.Object.create({
      clinica: null,
      fecha: null,
      lugar: null,
      obs: null,
      eliminado: false
    }));
    controller.set('medicamentoNuevo', Ember.Object.create({
      medicamento: null,
      frecuencia: null,
      motivo: null,
      eliminado: false
    }));
    controller.set('alergiaNueva', Ember.Object.create({
      fecha: null,
      alergia: null,
      eliminado: false
    }));
    controller.set('tieneTratamiento',false);
    controller.set('tieneDiagnostico',false);
    var mision = this.store.createRecord('campanha');
    console.log("mision", mision);
    var misionesVinculo = mision.get('misionesVinculo');
    controller.set('misionesVinculo', misionesVinculo);
    var detalles = controller.get('misionesVinculo');
    console.log('pasa');

    var vinculos = model.get('vinculos');


    if (vinculos && vinculos.misiones != null) {
      for (var i = 0; i < vinculos.misiones.length; i++) {
        var detalle = this.store.createRecord('misionVinculo');
        detalle.set('nombre', vinculos.misiones[i].nombre);
        detalle.set('descripcion', vinculos.misiones[i].descripcion);
        detalle.set('diagnostico', vinculos.misiones[i].diagnostico);
        detalle.set('tratamiento', vinculos.misiones[i].tratamiento);
        detalle.set('tipoTratamiento', vinculos.misiones[i].tipoTratamiento);
        detalle.set('tipoDiagnostico', vinculos.misiones[i].tipoDiagnostico);
        detalle.set('motivoNoSeOpero', vinculos.misiones[i].motivoNoSeOpero);
        detalle.set('recomendacionDental', vinculos.misiones[i].recomendacionDental);
        detalle.set('recomendacionFonoaudiologica', vinculos.misiones[i].recomendacionFonoaudiologica);
        detalles.addRecord(detalle);
      }
    }
    controller.set('agregandoMisionVinculo', false);

    var campanhas = this.store.find('campanha', {
      by_tipo_campanha: "Misión"
    });
    campanhas.then(function (response) {
      controller.set('misionesVinculoSelect', response);
      controller.set('misionVinculoSeleccionada', response.objectAt(0));
    });
    var diagnosticos = [{
      "tipo": "Labio",
      "nombre": "Normal",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Labio",
      "nombre": "Izq. Unilateral Incompleto",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Labio",
      "nombre": "Der. Unilateral Incompleto",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Labio",
      "nombre": "Izq. Unilateral Completo",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Labio",
      "nombre": "Der. Unilateral Completo",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Labio",
      "nombre": "Bilat. Izq. Completo / Der. Incompleto",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Labio",
      "nombre": "Bilat. Der. Completo / Inq. Incompleto",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Labio",
      "nombre": "Bilateral Incompleto",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Labio",
      "nombre": "Bilateral Completo",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Labio",
      "nombre": "Otro",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Labio",
      "nombre": "Labio Unilateral Reparado Previamente",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Labio",
      "nombre": "Labio Bilateral Reparado Previamente",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Nariz",
      "nombre": "Normal",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Nariz",
      "nombre": "Deformación Nasal Unilat. Izq.",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Nariz",
      "nombre": "Deformación Nasal Unilat. Der.",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Nariz",
      "nombre": "Deformación Nasal Bilateral",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Nariz",
      "nombre": "Deficiencia Bilateral de Columella",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Nariz",
      "nombre": "Desviación Septal",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Nariz",
      "nombre": "Otro",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Paladar",
      "nombre": "Normal",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Paladar",
      "nombre": "Izq. Unilat. Alveolar Incompleto",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Paladar",
      "nombre": "Izq. Unilat. Completo con Fisura Alveolar",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Paladar",
      "nombre": "Izq. Completo / Der. Incompleto",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Paladar",
      "nombre": "Der. Unilat. Alveolar Incompleto",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Paladar",
      "nombre": "Der. Unilat. Completo con Fisura Alveolar",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Paladar",
      "nombre": "Der. Completo / Inzq. Incompleto",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Paladar",
      "nombre": "Bilateral Incompleto",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Paladar",
      "nombre": "Bilateral Completo",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Paladar",
      "nombre": "Submucoso",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Paladar",
      "nombre": "Blando",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Paladar",
      "nombre": "Posterior Duro y Blando",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Paladar",
      "nombre": "Izq. Unilateral Completo Duro y Blando",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Paladar",
      "nombre": "Der. Unilateral Completo Duro y Blando",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Paladar",
      "nombre": "Bilateral Completo Duro y Blando",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Paladar",
      "nombre": "Otro",
      "tiene_observacion": true,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Paladar",
      "nombre": "Paladar Unilateral Reparado Previamente",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": true,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Paladar",
      "nombre": "Paladar Bilateral Reparado Previamente",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": true,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Paladar",
      "nombre": "Paladar Reparado con InsufiienciaVelofaríngea",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": true,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Fistula",
      "nombre": "Naso-labial Izq.",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Fistula",
      "nombre": "Alveolar Izq.",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Fistula",
      "nombre": "Alveolar y Anterior Izq.",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Fistula",
      "nombre": "Naso-Labial Der.",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Fistula",
      "nombre": "Alveolar Der.",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Fistula",
      "nombre": "Alveolar y Anterior Der.",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Fistula",
      "nombre": "Alveolar Der. y Izq.",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Fistula",
      "nombre": "Alveolar y Anterior Izq. y Der.",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Fistula",
      "nombre": "Alveolar Anterior y Media Izq. y Der.",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Fistula",
      "nombre": "Duro",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Fistula",
      "nombre": "Unión de Duro y Blando",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Fistula",
      "nombre": "Paladar Blando",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Fistula",
      "nombre": "Otro",
      "tiene_observacion": true,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Otros",
      "nombre": "Contractura por Quemadura",
      "tiene_observacion": false,
      "tiene_localizacion": true,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Otros",
      "nombre": "Malformación Craneofacial",
      "tiene_observacion": true,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Otros",
      "nombre": "Hemangioma",
      "tiene_observacion": false,
      "tiene_localizacion": true,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Otros",
      "nombre": "Microtia / Malformación Lóbulo de la Oreja",
      "tiene_observacion": false,
      "tiene_localizacion": true,
      "si_no": false,
      "tiene_lados": true,
      "lados": [
        "Nevo",
        "Lunar",
        "Tumor",
        "Quiste"
      ]
    }, {
      "tipo": "Otros",
      "nombre": "Ptosis Palpebral",
      "tiene_observacion": false,
      "tiene_localizacion": true,
      "si_no": false,
      "tiene_lados": true,
      "lados": [
        "Polidactilia",
        "Sindactilia"
      ]
    }, {
      "tipo": "Otros",
      "nombre": "Cicatriz por Quemadura",
      "tiene_observacion": false,
      "tiene_localizacion": true,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Otros",
      "nombre": "Otro tipo de Cicatriz",
      "tiene_observacion": false,
      "tiene_localizacion": true,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Otros",
      "nombre": "Frenillo Lingual",
      "tiene_observacion": true,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Otros",
      "nombre": "Otro",
      "tiene_observacion": true,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }];



    controller.set('diagnosticosArray', diagnosticos);
    var tiposDiagnosticos = [];
    for (var i = 0; i < diagnosticos.length; i++) {
      if (!tiposDiagnosticos.includes(diagnosticos[i].tipo)) {
        tiposDiagnosticos.push(diagnosticos[i].tipo);
      }
    }

    controller.set('tiposDiagnosticos', tiposDiagnosticos);

    var tratamientos = [{
      "tipo": "Labio",
      "nombre": "Reparación Unilateral Primaria",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Labio",
      "nombre": "Reparación Bilateral Primaria",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Labio",
      "nombre": "Reparación Unilateral Secundaria",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Labio",
      "nombre": "Reparación  Bilateral Secundaria",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Labio",
      "nombre": "Revisión de Cicatriz",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Labio",
      "nombre": "Otro",
      "tiene_observacion": true,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Nariz",
      "nombre": "Reparación Nasal Unilateral",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Nariz",
      "nombre": "Reparación Nasal Bilateral",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Nariz",
      "nombre": "Reparación de Septo Desviado",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Nariz",
      "nombre": "Rinoplastia (hueso y cartílago)",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Nariz",
      "nombre": "Injerto de Cartílago",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Nariz",
      "nombre": "Otro",
      "tiene_observacion": true,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Paladar",
      "nombre": "Reparación Primaria",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Paladar",
      "nombre": "Revisión",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Paladar",
      "nombre": "Orticochea",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Paladar",
      "nombre": "Colgajo Faríngeo",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Paladar",
      "nombre": "Vomer / Colgajo Nasal",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Paladar",
      "nombre": "Otro",
      "tiene_observacion": true,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Otros",
      "nombre": "Liberación de Contractura e Injerto de Piel de Espesor Completo",
      "tiene_observacion": true,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Otros",
      "nombre": "Liberación de Contractura e Injerto de Piel de Espesor Parcial",
      "tiene_observacion": true,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Otros",
      "nombre": "Liberación de Contractura con Zetaplastía",
      "tiene_observacion": true,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Otros",
      "nombre": "Reparación Craneofacial",
      "tiene_observacion": true,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Otros",
      "nombre": "Excisión de Nevo / Lunar / Tumor / Quiste",
      "tiene_observacion": true,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Otros",
      "nombre": "Frenilectomía",
      "tiene_observacion": true,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Otros",
      "nombre": "Hemangioma",
      "tiene_observacion": true,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Otros",
      "nombre": "Otoplastía",
      "tiene_observacion": true,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Otros",
      "nombre": "Reparación Ptosis",
      "tiene_observacion": true,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Otros",
      "nombre": "Polidactilia / Sindactilia",
      "tiene_observacion": true,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Otros",
      "nombre": "Excisión de Cicatriz con Injerto de Piel de Espesor Total",
      "tiene_observacion": true,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Otros",
      "nombre": "Excisión de Cicatriz con Injerto de Piel de Espesor Parcial",
      "tiene_observacion": true,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Otros",
      "nombre": "Excisión de Cicatriz con Zetaplastía",
      "tiene_observacion": true,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Otros",
      "nombre": "Inyección de Cicatriz",
      "tiene_observacion": true,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Otros",
      "nombre": "Otro",
      "tiene_observacion": true,
      "tiene_localizacion": false,
      "si_no": false,
      "tiene_lados": false,
      "lados": null
    }];

    controller.set('tratamientosArray', tratamientos);

    var tiposTratamientos = [];
    for (var i = 0; i < tratamientos.length; i++) {
      if (!tiposTratamientos.includes(tratamientos[i].tipo)) {
        tiposTratamientos.push(tratamientos[i].tipo);
      }
    }
    controller.set('tiposTratamientos', tiposTratamientos);
  }
});


var seatearListaCiudades = function (ciudad, controller) {
  controller.store.find('ciudad', {
    unpaged: true
  }).then(function (response) {
    controller.set('ciudades', response);
    if (ciudad) {
      controller.set('ciudadDefault', ciudad.get('codigo'));
      controller.set('ciudadEmpleadorDefault', ciudad.get('codigo'));
    } else {
      controller.set('ciudadDefault', response.objectAt(0).get('codigo'));
      controller.set('ciudadEmpleadorDefault', response.objectAt(0).get('codigo'));
    }
  });

};

var incializarDatosFamiliares = function () {
  var datosFamiliares = {};
  var padres = ["madre", "padre"];
  datosFamiliares.numeroHermanos = "";
  datosFamiliares.edadesHermanos = "";
  datosFamiliares.comparteVivienda = "";
  padres.forEach(function (p) {
    datosFamiliares[p] = {};
    datosFamiliares[p].nombre = "";
    datosFamiliares[p].edad = 0;
    datosFamiliares[p].escolaridad = "";
    datosFamiliares[p].ocupacion = "";
  });
  return datosFamiliares;
};

var incializarDatosImportantes = function () {
  var datos = {};
  datos.cirugias = [];
  datos.alergias = [];
  datos.medicamentos = [];
  datos.embarazo = false;
  datos.problemas = {};
  datos.problemas.sindromes = null;
  datos.problemas.auditivos = null;
  datos.problemas.visuales = null;
  datos.problemas.neuromusculares = {
    debilidad: false,
    desarrollo: false,
    convulsiones: false
  };
  datos.problemas.respiratorios = {
    asma: false,
    difRespiratoria: false,
    neumonia: false,
    infRespiratoria: false
  };
  datos.problemas.cardiacos = {
    congenito: false,
    miocarditis: false,
    soplo: false,
    hipertension: false,
    perturbacion: false,
    cardiopatiaReumatica: false,
    valvulas: false
  };
  datos.problemas.infecciones = {
    VIH: false,
    hepatitis: false,
    malaria: false,
    otros: null
  }
  datos.problemas.otros = null;

  return datos;
};

//se inicializan las estructuras de dato json para los formularios
var initNoSqlModel = function (controller) {
  controller.set('datosFamiliares', incializarDatosFamiliares());
  controller.set('contactoEmergencia', {
    nombre: "",
    relacion: "",
    telefono: ""
  });

  controller.set('vinculos', {
    asistencia: "",
    misionAsociada: "",
    sigueTratamiento: "",
    fechaPrimeraConsulta: "",
    comoSeEntero: {
      detalle: ""
    }
  });

  controller.set('otrosDatos', {
    dondeSiguioTratamientoPediatrico: "",
    tieneSeguro: "",
    empresaDeSeguro: ""
  });
  controller.set('datosImportantes', incializarDatosImportantes());
};

Bodega.PacienteEditRoute = Bodega.PacienteBaseRoute.extend({
  model: function (params) {
    return this.modelFor('paciente');
  },

  setupController: function (controller, model) {
    this.setupCommonProps(controller, model);
    var persona = model.get('persona');
    var ciudad = persona.get('ciudad');
    var conyugue = persona.get('conyugue');
    var self = this;
    if (!conyugue) {
      persona.set('conyugue', this.store.createRecord('conyugue'));
      console.log('PERSONA', persona);
    }

    controller.set('datosFamiliares', model.get('datosFamiliares'));
    controller.set('contactoEmergencia', model.get('contactoEmergencia'));
    controller.set('vinculos', model.get('vinculos'));
    controller.set('otrosDatos', model.get('otrosDatos'));
    controller.set('datosImportantes', model.get('datosImportantes'));

    this.store.find('fichaCirugia', {'paciente_id': model.get('id')}).then(function (response) {
      console.log('responselength',response.content.length);
      console.log('response',response.objectAt(0));
      if (response.content.length > 0) {
        var tratamientos = response.objectAt(0).get('tratamientosRealizados.tratamientos');
        if(tratamientos && tratamientos.length >0){
          console.log('tratamientos',tratamientos);


          var tratamiento = controller.store.createRecord('tratamientoFichaCirugia');

          var tratamientoDetalles = tratamiento.get('tratamientoDetalles');
          controller.set('detallesTratamientos', tratamientoDetalles);
          var detallesTratamientos = controller.get('detallesTratamientos');
          var tratamientosRealizados = model.get('tratamientosRealizados');

            for (var i = 0; i < tratamientos.length; i++) {
              var detalleTratamiento = controller.store.createRecord('tratamientoDetalle');
              detalleTratamiento.set('nombre', tratamientos[i].nombre);
              detalleTratamiento.set('tipo', tratamientos[i].tipo);
              detalleTratamiento.set('observacion', tratamientos[i].observacion);
              detalleTratamiento.set('hospital', tratamientos[i].hospital);
              detalleTratamiento.set('anhoMision', tratamientos[i].anhoMision);
              detalleTratamiento.set('campanha', tratamientos[i].campanha);
              detalleTratamiento.set('resultadoSatisfactorio', tratamientos[i].resultadoSatisfactorio);
              detalleTratamiento.set('externo', tratamientos[i].externo);
              detalleTratamiento.set('estadoTratamiento', tratamientos[i].estadoTratamiento);
              detallesTratamientos.addRecord(detalleTratamiento);
            }
          controller.set('listaCirugiasFicha',detallesTratamientos);
        }else{
          controller.set('listaCirugiasFicha',false);
        }
      }
    });
    if (!controller.get('datosImportantes.cirugias')) {
      controller.set('datosImportantes.cirugias', []);
    };
    if (!controller.get('datosImportantes.medicamentos')) {
      controller.set('datosImportantes.medicamentos', []);
    };
    if (!controller.get('datosImportantes.alergias')) {
      controller.set('datosImportantes.alergias', []);
    };
    //TODO:
    seatearListaCiudades(ciudad, controller);
    this.store.find('ciudad', {
      unpaged: true
    }).then(function (response) {
      controller.set('ciudades', response);
      if (ciudad) {
        controller.set('ciudadDefault', ciudad.get('codigo'));
        controller.set('ciudadEmpleadorDefault', ciudad.get('codigo'));
      } else {
        controller.set('ciudadDefault', response.objectAt(0).get('codigo'));
        controller.set('ciudadEmpleadorDefault', response.objectAt(0).get('codigo'));
      }
    });

    //Ahora inicializamos los datos que son solicitados por candidaturas
    var medianteOptions = [{
      id: 'Misión',
      descripcion: 'Misión'
    }, {
      id: 'Clínica',
      descripcion: 'Clínica'
    }];
    controller.set('medianteOptions', medianteOptions);
    controller.set('medianteDefault', medianteOptions[0]);
    this.store.find('campanha', {
      'by_tipo_mision': true
    }).then(function (response) {
      controller.set('campanhas', response);
      controller.set('campanhaDefault', response.objectAt(0));
    });
    this.store.find('especialidad', { unpaged: true , habilita_consulta: true }).then(function (response) {
      controller.set('especialidades', response);
      console.log('response',response.objectAt(0));
      controller.set('especialidadDefault', response.objectAt(0));
      controller.set('especialidadSeleccionada', response.objectAt(0));
      self.store.find('colaborador', {'unpaged': true, 'by_especialidad_id': controller.get('especialidadDefault').get('id'),'by_activo':true}).then(function (response) {
        controller.set('colaboradores', response);
        controller.set('colaboradorDefault', response.objectAt(0));
        controller.set('colaboradorSeleccionado', response.objectAt(0));
      });
    });

    controller.set('nuevaCandidatura', false);
  },

  renderTemplate: function () {
    this.render('pacientes.new', {
      controller: 'pacienteEdit'
    });
  }
});

Bodega.PacientesNewRoute = Bodega.PacienteBaseRoute.extend({
  model: function () {
    console.log("geting and returning model");
    var model = this.store.createRecord('paciente');
    var persona = this.store.createRecord('persona');
    //var fichaFonoaudiologia = this.store.createRecord('fichaFonoaudiologia');
    //no eliminar conyuge o deja de funcionar
    var conyugue = this.store.createRecord('conyugue');
    persona.set('conyugue', conyugue);
    model.set('persona', persona);

    return model;
  },

  setupController: function (controller, model) {
    this.setupCommonProps(controller, model);
    var persona = model.get('persona');
    var ciudad = persona.get('ciudad');
    initNoSqlModel(controller);
    seatearListaCiudades(ciudad, controller);
  }
});

Bodega.PacienteDeleteRoute = Bodega.AuthenticatedRoute.extend({
  model: function (params) {
    return this.modelFor('paciente');
  },

  renderTemplate: function () {
    this.render('pacientes.delete', {
      controller: 'pacienteDelete'
    });
  }
});
