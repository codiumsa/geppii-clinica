Bodega.Curso = DS.Model.extend({
  descripcion: DS.attr('string'),
  observaciones: DS.attr('string'),
  lugar: DS.attr('string'),
  fechaInicio: DS.attr('isodate'),
  fechaFin: DS.attr('isodate'),
  cursoColaboradores: DS.hasMany('cursoColaborador',{ async: true })
});
