
Bodega.ConsultaLista = DS.Model.extend({
  colaborador: DS.belongsTo('colaborador', {async: true}),
  especialidad: DS.belongsTo('especialidad', {async: true}),
  fechaAgenda: DS.attr('date')
});
