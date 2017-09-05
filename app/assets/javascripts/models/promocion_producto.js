// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.PromocionProducto = DS.Model.extend({
  promocion: DS.belongsTo('promocion', { async: true }),
  producto: DS.belongsTo('producto', { async: true }),
  cantidad: DS.attr('number', {defaultValue: 1}),
  porcentaje: DS.attr('boolean', {defaultValue: false}),
  precioDescuento: DS.attr('number', {defaultValue: 0}),
  dirty: DS.attr('boolean', {defaultValue: false}),
  moneda: DS.belongsTo('moneda', { async:true }),
  caliente: DS.attr('boolean', {defaultValue: false})
});
