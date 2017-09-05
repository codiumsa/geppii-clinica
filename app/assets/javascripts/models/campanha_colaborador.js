// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.CampanhaColaborador = DS.Model.extend({
  colaborador: DS.belongsTo('colaborador', { async: true }),
  campanha: DS.belongsTo('campanha', { async: true }),
  observaciones: DS.attr('string')
});
