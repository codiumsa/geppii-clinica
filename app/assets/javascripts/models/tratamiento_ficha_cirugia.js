Bodega.TratamientoFichaCirugia = DS.Model.extend({
  tipo: DS.attr('string'),
  tratamientoDetalles: DS.hasMany('tratamientoDetalle')
});
