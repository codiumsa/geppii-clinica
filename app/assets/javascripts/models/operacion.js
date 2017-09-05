// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Operacion = DS.Model.extend({
  tipoOperacion: DS.belongsTo('tipoOperacion',{async:true}),
  categoriaOperacion: DS.belongsTo('categoriaOperacion',{async:true}),
  monto: DS.attr('number',{defaultValue: 0}),
  caja: DS.belongsTo('caja', {async:true}),
  cajaDestino: DS.belongsTo('caja', {async:true}),
  moneda: DS.belongsTo('moneda',{async:true}),
  movimientos: DS.hasMany('movimiento', { async: true }),
  referenciaId: DS.attr('number'),
  reversado: DS.attr('boolean')
});
