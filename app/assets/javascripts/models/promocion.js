// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Promocion = DS.Model.extend({
  detalle: DS.hasMany('promocionProducto', { async: true }),
  tipo: DS.attr('string'),
  descripcion: DS.attr('string'),
  permanente: DS.attr('boolean', {defaultValue: false}),
  exclusiva: DS.attr('boolean', {defaultValue: false}),
  fechaVigenciaDesde: DS.attr('isodate', {
      defaultValue: function() { return new Date(); }
  }),
  fechaVigenciaHasta: DS.attr('isodate', {
      defaultValue: function() { return new Date(); }
  }),
  cantidadGeneral: DS.attr('number', {defaultValue: 0}),
  porcentajeDescuento: DS.attr('number', {defaultValue: 0}),
  conTarjeta: DS.attr('boolean', {defaultValue: false}),
  aPartirDe: DS.attr('boolean', {defaultValue: false}),
  porUnidad: DS.attr('boolean', {defaultValue: false}),
  activo: DS.attr('boolean', {defaultValue: true}),
  tarjeta: DS.belongsTo('tarjeta', {async:true})
});