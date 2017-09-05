Bodega.Diagnostico = DS.Model.extend({
  tipo: DS.attr('string'),
  diagnosticoDetalles: DS.hasMany('diagnosticoDetalle')
});
