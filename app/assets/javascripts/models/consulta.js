// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Consulta = DS.Model.extend({
  colaborador: DS.belongsTo('colaborador', {async: true}),
  especialidad: DS.belongsTo('especialidad', {async: true}),
  paciente: DS.belongsTo('paciente', {async: true}),
  consultaDetalles: DS.hasMany('consultaDetalle', {async: true}),
  consultaListas: DS.hasMany('consultaLista', {async: true}),
  fechaAgenda: DS.attr('date'),
  fechaInicio: DS.attr('date'),
  fechaFin: DS.attr('date'),
  estado: DS.attr('string'),
  cobrar: DS.attr('boolean'),
  nroFicha: DS.attr('number'),
  evaluacion: DS.attr('string'),
  diagnostico: DS.attr('string'),
  receta: DS.attr('string'),
  evaluacion: DS.attr('string'),
  indicaciones: DS.attr('string')
});
