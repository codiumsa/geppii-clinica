// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.FichaNutricion = DS.Model.extend({
  paciente: DS.belongsTo('paciente', { async: true }),
  nroFicha: DS.attr('number'),
  datos: DS.attr('json'),
  updatedAt: DS.attr('isodate'),
  consultaId: DS.attr('number')
});
