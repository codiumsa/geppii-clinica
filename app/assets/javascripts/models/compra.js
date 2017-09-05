// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Compra = DS.Model.extend({
  sucursal: DS.belongsTo('sucursal',{ async: true }),
  campanha: DS.belongsTo('campanha',{ async: true }),
  sponsor: DS.belongsTo('sponsor',{ async: true }),
  proveedor: DS.belongsTo('proveedor',{ async: true }),
  compraDetalles: DS.hasMany('compraDetalle',{ async: true }),
  compraCuota: DS.hasMany('compraCuota',{ async: true }),
  total: DS.attr('number'),
  iva10: DS.attr('number'),
  iva5: DS.attr('number'),
  credito: DS.attr('boolean', {defaultValue: false}),
  donacion: DS.attr('boolean', {defaultValue: false}),
  pagado: DS.attr('boolean',{defaultValue: false}),
  cantidadCuotas: DS.attr('number', {defaultValue: 0}),
  nroFactura: DS.attr('string'),
  tipoCredito: DS.belongsTo('tipoCredito', { async: true }),
  compraCuota: DS.hasMany('compraCuota', { async: true }),
  deuda: DS.attr('number', {defaultValue: 0}),
  deposito: DS.belongsTo('deposito', { async: true }),
  retencioniva: DS.attr('number', {defaultValue: 0}),
  periodos: DS.attr('string'),
  razonSocialProveedor: DS.attr('string'),
  nroCheque: DS.attr('string'),
  nroCuenta: DS.attr('string'),
  banco: DS.attr('string'),
  nroOrdenCompra: DS.attr('string'),
  tarjeta: DS.belongsTo('tarjeta', {async:true}),
  medioPago: DS.belongsTo('medioPago',{ async: true }),
  imprimirRetencion: DS.attr('boolean', {defaultValue: false}),
  fechaRegistro: DS.attr('isodate', {
      defaultValue: function() {
        return moment().toDate();
      }
  }),
  moneda: DS.belongsTo('moneda', { async: true }),
  cotizacion: DS.belongsTo('cotizacion', { async: true }),
  montoCotizacion: DS.attr('number'),
});
