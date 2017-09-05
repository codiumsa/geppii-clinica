Bodega.FichaCirugiaBaseRoute = Bodega.ClinicaBaseRoute.extend({
  setupController: function(controller, model, params) {
    this._super(controller, model, params, 'CIR');
    controller.set('estadosTratamiento', ['Realizado', 'Recomendado']);
    controller.set('origenFicha', ['Con Operación Sonrisa', 'Externo']);
    controller.set('ubicacionFicha', ['Misión', 'Clínica']);
    controller.set('mostrarCheckMision', true);
    controller.set('listaDiagnosticos', []);

    controller.set('agregandoDiagnostico', false);
    controller.set('agregandoTratamiento', false);

    var diagnostico = controller.store.createRecord('diagnostico');
    var diagnosticoDetalles = diagnostico.get('diagnosticoDetalles');
    controller.set('detallesDiagnosticos', diagnosticoDetalles);
    var detalles = controller.get('detallesDiagnosticos');
    var diagnosticosRealizados = model.get('diagnosticosRealizados');

    if (diagnosticosRealizados && diagnosticosRealizados.diagnosticos != null) {
      for (var i = 0; i < diagnosticosRealizados.diagnosticos.length; i++) {
        var detalle = this.store.createRecord('diagnosticoDetalle');
        console.log(diagnosticosRealizados.diagnosticos[i].nombre);
        detalle.set('nombre', diagnosticosRealizados.diagnosticos[i].nombre);
        detalle.set('tipo', diagnosticosRealizados.diagnosticos[i].tipo);
        detalle.set('resultadoSatisfactorio', diagnosticosRealizados.diagnosticos[i].resultadoSatisfactorio);
        detalle.set('observacion', diagnosticosRealizados.diagnosticos[i].observacion);
        detalle.set('lado', diagnosticosRealizados.diagnosticos[i].lado);
        detalle.set('localizacion', diagnosticosRealizados.diagnosticos[i].localizacion);
        detalles.addRecord(detalle);
      }

    }
    var tratamiento = controller.store.createRecord('tratamientoFichaCirugia');

    var tratamientoDetalles = tratamiento.get('tratamientoDetalles');
    controller.set('detallesTratamientos', tratamientoDetalles);
    var detallesTratamientos = controller.get('detallesTratamientos');
    var tratamientosRealizados = model.get('tratamientosRealizados');

    if (tratamientosRealizados && tratamientosRealizados.tratamientos != null) {
      for (var i = 0; i < tratamientosRealizados.tratamientos.length; i++) {
        var detalleTratamiento = this.store.createRecord('tratamientoDetalle');
        console.log(tratamientosRealizados.tratamientos[i].nombre);
        detalleTratamiento.set('nombre', tratamientosRealizados.tratamientos[i].nombre);
        detalleTratamiento.set('tipo', tratamientosRealizados.tratamientos[i].tipo);
        detalleTratamiento.set('observacion', tratamientosRealizados.tratamientos[i].observacion);
        detalleTratamiento.set('hospital', tratamientosRealizados.tratamientos[i].hospital);
        detalleTratamiento.set('anhoMision', tratamientosRealizados.tratamientos[i].anhoMision);
        detalleTratamiento.set('campanha', tratamientosRealizados.tratamientos[i].campanha);
        detalleTratamiento.set('resultadoSatisfactorio', tratamientosRealizados.tratamientos[i].resultadoSatisfactorio);
        detalleTratamiento.set('externo', tratamientosRealizados.tratamientos[i].externo);
        detalleTratamiento.set('estadoTratamiento', tratamientosRealizados.tratamientos[i].estadoTratamiento);
        detallesTratamientos.addRecord(detalleTratamiento);
      }
    }

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
    controller.set('tieneResultadoSatisfactorioTratamiento', false);
    controller.set('resultadoSatisfactorioTratamiento', false);
    controller.set('tieneObservacionTratamiento', false);

    var tiposTratamientos = [];
    for (var i = 0; i < tratamientos.length; i++) {
      if (!tiposTratamientos.includes(tratamientos[i].tipo)) {
        tiposTratamientos.push(tratamientos[i].tipo);
      }
    }
    controller.set('tiposTratamientos', tiposTratamientos);

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
      "si_no": true,
      "tiene_lados": false,
      "lados": null
    }, {
      "tipo": "Labio",
      "nombre": "Labio Bilateral Reparado Previamente",
      "tiene_observacion": false,
      "tiene_localizacion": false,
      "si_no": true,
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
    controller.set('tieneResultadoSatisfactorio', false);
    controller.set('resultadoSatisfactorio', false);
    controller.set('tieneObservacion', false);
    var tiposDiagnosticos = [];
    for (var i = 0; i < diagnosticos.length; i++) {
      if (!tiposDiagnosticos.includes(diagnosticos[i].tipo)) {
        tiposDiagnosticos.push(diagnosticos[i].tipo);
      }
    }

    controller.set('tiposDiagnosticos', tiposDiagnosticos);


    if (model.get('externo')) {
      controller.set('habilitaUbicacion', false);
      controller.set('origenSeleccionado', controller.get('origenFicha')[1]);
    } else {
      controller.set('origenSeleccionado', controller.get('origenFicha')[0]);
      controller.set('habilitaUbicacion', true);
    }
    var campanhaModel = model.get('campanha');
    if (campanhaModel) {
      campanhaModel.then(function(response) {
        controller.set('habilitaMisiones', true);
        controller.set('anhoController', null);
        controller.set('campanhaLabel', response.get('nombre'));
      });

    } else {
      controller.set('habilitaMisiones', false);
      controller.set('anhoController', model.get('anhoMision'));
    }





    if (model.get('tratamientosRealizados')) {
      controller.set('listaTratamientos', model.get('tratamientosRealizados'));
    } else {
      var listaTratamientos = [
        { titulo: "Labio Primario", edad: null, fecha: null, lugar: null }, { titulo: "Paladar Primario", edad: null, fecha: null, lugar: null },
        { titulo: "Cierre de Fistulas", edad: null, fecha: null, lugar: null }, { titulo: "Injerto Alveolar", edad: null, fecha: null, lugar: null },
        { titulo: "Miringotomia", edad: null, fecha: null, lugar: null }, { titulo: "Rinoplastia", edad: null, fecha: null, lugar: null },
        { titulo: "Correccion IVF", edad: null, fecha: null, lugar: null }, { titulo: "RevisionLabio", edad: null, fecha: null, lugar: null },
        { titulo: "Otros", edad: null, fecha: null, lugar: null }
      ];
      controller.set('listaTratamientos', listaTratamientos);
    }
    var colaboradorSeleccionado = model.get('colaborador');
    if (colaboradorSeleccionado) {
      colaboradorSeleccionado.then(function(response) {
        controller.set('colaboradorLabel', response._data.razonSocial);
      });
    }



    controller.set('model', model);
  }
});

Bodega.FichasCirugiaNewRoute = Bodega.FichaCirugiaBaseRoute.extend({
  queryParams: {
    paciente_id: { replace: true }
  },

  model: function() {
    this.store.find('fichaCirugia', { page: 1 });
    var model = this.store.createRecord('fichaCirugia');
    return model;
  },
  renderTemplate: function() {
    this.render('fichas_cirugia.new', {
      controller: 'fichasCirugiaNew'
    });
  }
});


Bodega.FichaCirugiaEditRoute = Bodega.FichaCirugiaBaseRoute.extend({
  model: function(params) {
    return this.modelFor('fichaCirugia');
  },
  renderTemplate: function() {
    this.render('fichas_cirugia.new', {
      controller: 'fichaCirugiaEdit'
    });
  }
});
