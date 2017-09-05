Bodega.Viaje = DS.Model.extend({
  descripcion: DS.attr('string'),
  observaciones: DS.attr('string'),
  origen: DS.attr('string'),
  destino: DS.attr('string'),
  fechaInicio: DS.attr('isodate'),
  fechaFin: DS.attr('isodate'),
  viajeColaboradores: DS.hasMany('viajeColaborador',{ async: true })
});
