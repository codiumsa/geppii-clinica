// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.FichaCirugia = DS.Model.extend({
  tratamientosRealizados: DS.attr('json'),
  diagnosticosRealizados: DS.attr('json'),
  colaborador: DS.belongsTo('colaborador', { async: true }),
  paciente: DS.belongsTo('paciente', { async: true }),
  campanha: DS.belongsTo('campanha', { async: true }),
  necesitaCirugia: DS.attr('boolean', {defaultValue: false}),
  externo: DS.attr('boolean', {defaultValue: false}),
  updatedAt: DS.attr('isodate'),
  fechaConsultaInicial: DS.attr('isodate', {
      defaultValue: function() {
        return moment().toDate();
      }
  }),
  comentariosAdicionales: DS.attr('string'),
  diagnosticoInicial: DS.attr('string'),
  estado: DS.attr('string'),
  nroFicha: DS.attr('number'),
  anhoMision: DS.attr('number'),
  consultaId: DS.attr('number')
});
