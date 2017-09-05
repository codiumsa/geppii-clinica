// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.TransferenciaDepositoDetalle = DS.Model.extend({
  lote: DS.belongsTo('lote', { async: true }),
  transferencia: DS.belongsTo('transferenciaDeposito', { async: true }),
  cantidad: DS.attr('number', {defaultValue: 1})
});
