// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.InventarioProducto = DS.Model.extend({
  existencia: DS.attr('number'),
  existenciaPrevia: DS.attr('number'),
  inventario: DS.belongsTo('inventario', {async: true}),
  producto: DS.belongsTo('producto', {async: true})
});
