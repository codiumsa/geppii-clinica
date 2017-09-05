// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.FichaOdontologia = DS.Model.extend({
  recienNacido: DS.attr('json'),
  examenClinico: DS.attr('json'),
  odontograma: DS.attr('json'),
  preescolarAdolescente: DS.attr('json'),
  paciente: DS.belongsTo('paciente', { async: true }),
  nroFicha: DS.attr('number'),
  updatedAt: DS.attr('isodate'),
  consultaId: DS.attr('number'),
  estado: DS.attr('string'),
  consultaDetalles: DS.hasMany('consultaDetalle', {async: true})
});
