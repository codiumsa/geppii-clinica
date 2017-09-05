// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Recargo = DS.Model.extend({
  cantidadCuotas: DS.attr('number'),
  interes: DS.attr('number'),
  tipoCredito: DS.belongsTo('tipoCredito', { async: true }),
  medioPago: DS.belongsTo('medioPago', { async: true })
});
