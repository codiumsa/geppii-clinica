// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.AjusteInventarioDetalle = DS.Model.extend({
  cantidad: DS.attr('number'),
  ajusteInventario: DS.belongsTo('ajusteInventario', {async: true}),
  motivosInventario: DS.belongsTo('motivosInventario', {async: true}),
  lote: DS.belongsTo('lote', {async: true}),
  producto: DS.belongsTo('producto', {async: true})
});
