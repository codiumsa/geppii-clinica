Bodega.CursoColaborador = DS.Model.extend({
  curso: DS.belongsTo('curso', { async: true }),
  colaborador: DS.belongsTo('colaborador', { async: true }),
  observacion: DS.attr('string')
});
