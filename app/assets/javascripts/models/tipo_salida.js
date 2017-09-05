Bodega.TipoSalida = DS.Model.extend({
  codigo: DS.attr('string'),
  descripcion: DS.attr('string'),
  muestraMediosPago: DS.attr('boolean', {defaultValue: false})
});
