// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.ProductoDetalle = DS.Model.extend({
  productoPadre: DS.belongsTo('producto', { async: true}),
  producto: DS.belongsTo('producto', { async: true}),
  cantidad: DS.attr('number', {defaultValue: 1})
});
