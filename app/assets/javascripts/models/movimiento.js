// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Movimiento = DS.Model.extend({
  caja: DS.belongsTo('caja', { async: true }),
  operacion: DS.belongsTo('operacion', { async: true }),
  tipoOperacionDetalle: DS.belongsTo('tipoOperacionDetalle', { async: true }),
  moneda: DS.belongsTo('moneda', { async: true }),
  monto: DS.attr('number'),
  montoCotizado: DS.attr('number'),
  descripcion: DS.attr('string'),
  saldo: DS.attr('number'),
  referencia: DS.attr('string'),
  montoDebito: function(){
    return (this.get('monto')*-1);
  }.property('monto')
});

