// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Pago = DS.Model.extend({
  fechaPago: DS.attr('isodate', {
      defaultValue: function() {
        return moment().toDate();
      }
  }),
  estado: DS.attr('string'),
	bancoCheque: DS.attr('string'),
	numeroCheque: DS.attr('string'),
  fechaActualizacionInteres: DS.attr('date'),
  total: DS.attr('number'),
	totalMonedaSeleccionada: DS.attr('number'),
	descuentoMonedaSeleccionada: DS.attr('number'),
  montoCotizacion: DS.attr('number'),
  venta: DS.belongsTo('venta', { async: true }),
  compra: DS.belongsTo('compra', { async: true }),
  moneda: DS.belongsTo('moneda', { async: true }),
	usuarioAprobacionDescuento: DS.belongsTo('usuario', {async:true}),
	usuarioSolicitudDescuento: DS.belongsTo('usuario', {async:true}),
	pagoDetalles: DS.hasMany('pagoDetalle', { async: true }),
  borrado: DS.attr('boolean'),
  descuento: DS.attr('number'),
  nroRecibo: DS.attr('string')
});
