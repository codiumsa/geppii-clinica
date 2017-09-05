Bodega.ProduccionDetalle = DS.Model.extend({
  cantidad: DS.attr('number'),
  lote: DS.belongsTo('lote', {async : true}),
  deposito: DS.belongsTo('deposito', {async : true}),
  producto: DS.belongsTo('producto', {async : true}),
  produccion: DS.belongsTo('produccion', { async: true })
});
