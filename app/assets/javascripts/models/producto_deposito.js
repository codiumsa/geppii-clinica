// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.ProductoDeposito = DS.Model.extend({
  producto: DS.belongsTo('producto'),
  deposito: DS.belongsTo('deposito'),
  existencia: DS.attr('number')
});
