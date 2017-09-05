Bodega.ProcesoDetalle = DS.Model.extend({
  proceso: DS.belongsTo('proceso', { async: true }),
  producto: DS.belongsTo('producto', { async: true }),
  cantidad: DS.attr('number'),
  precioCosto: DS.attr('number'),
  precioVenta: DS.attr('number')
});
