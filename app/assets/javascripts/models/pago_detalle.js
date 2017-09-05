// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.PagoDetalle = DS.Model.extend({
  montoCuota: DS.attr('number'),
  montoInteres: DS.attr('number'),
  montoInteresMoratorio: DS.attr('number'),
  montoInteresPunitorio: DS.attr('number'),
  pago: DS.belongsTo('pago', { async: true }),
  compraCuota: DS.belongsTo('compraCuota', { async: true }),
  ventaCuota: DS.belongsTo('ventaCuota', { async: true }), 
	numeroCuotaAsociado: DS.attr('number'),
});
