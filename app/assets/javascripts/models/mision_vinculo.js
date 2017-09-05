Bodega.MisionVinculo = DS.Model.extend({
    nombre: DS.attr('string'),
    descripcion: DS.attr('string'),
    diagnostico: DS.attr('string'),
    tipoDiagnostico: DS.attr('string'),
    tratamiento: DS.attr('string'),
    tipoTratamiento: DS.attr('string'),
    motivoNoSeOpero: DS.attr('string'),
    recomendacionDental: DS.attr('string'),
    recomendacionFonoaudiologica: DS.attr('string')
});