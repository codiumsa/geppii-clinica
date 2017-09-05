// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.InventarioLote = DS.Model.extend({
  existencia: DS.attr('number'),
  existenciaPrevia: DS.attr('number'),
  inventario: DS.belongsTo('inventario', {async: true}),
  lote: DS.belongsTo('lote', {async: true}),
  producto: DS.belongsTo('producto', {async: true})
});
