Bodega.FichaPsicologia = DS.Model.extend({
  paciente: DS.belongsTo('paciente', { async: true }),
  colaborador: DS.belongsTo('colaborador', { async: true }),
  nroFicha: DS.attr('number'),
  estado: DS.attr('string'),
  comentarios: DS.attr('string'),
  confidencial: DS.attr('string'),
  updatedAt: DS.attr('isodate'),
  consultaId: DS.attr('number')
});
