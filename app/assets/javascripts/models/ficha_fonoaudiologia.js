// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.FichaFonoaudiologia = DS.Model.extend({
  prioridad: DS.attr('number'),
  comunicacionLenguaje: DS.attr('json'),
  alimentacion: DS.attr('json'),
  estimulos: DS.attr('json'),
  fistula: DS.attr('json'),
  updatedAt: DS.attr('isodate'),
  paciente: DS.belongsTo('paciente', { async: true }),
  consultaId: DS.attr('number'),
  nroFicha: DS.attr('number'),
  estado: DS.attr('string')

});
