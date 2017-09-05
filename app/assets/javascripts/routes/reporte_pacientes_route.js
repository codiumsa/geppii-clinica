Bodega.ReportePacientesIndexRoute = Bodega.AuthenticatedRoute.extend({
  setupController: function(controller, model) {
    medicamentoParams = {};
    medicamentoParams.unpaged = true;
    medicamentoParams.by_tipo_producto = 'M';

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
    }];

    controller.set('tratamientos', tratamientos);

    this.store.find('producto', medicamentoParams).then(function(response){
        controller.set('medicamentos', response);
    });
  }
});

Bodega.ReportePacientes = Bodega.AuthenticatedRoute.extend({});