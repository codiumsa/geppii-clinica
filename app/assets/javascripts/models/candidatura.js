// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Candidatura = DS.Model.extend({
  paciente: DS.belongsTo('paciente'),
  especialidad: DS.belongsTo('especialidad'),
  colaborador: DS.belongsTo('colaborador'),
  fecha: DS.attr('date'),
  clinica: DS.attr('boolean'),
  campanha: DS.belongsTo('campanha'),
  fechaPosible: DS.attr('date')
});
