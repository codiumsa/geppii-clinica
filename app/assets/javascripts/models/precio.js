// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Precio = DS.Model.extend({
  fecha: DS.attr('isodate'),
  precioCompra: DS.attr('number'),
  compraDetalle: DS.belongsTo('CompraDetalle')
});
