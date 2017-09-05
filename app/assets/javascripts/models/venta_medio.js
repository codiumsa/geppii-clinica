// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.VentaMedio = DS.Model.extend({
  venta: DS.belongsTo('venta', { async: true }),
  medioPago: DS.belongsTo('medioPago', { async: true }),
  tarjeta: DS.belongsTo('tarjeta', {async:true}),
  monto: DS.attr('number', {defaultValue: 0}),
  vuelto: DS.attr('number', {defaultValue: 0})
});
