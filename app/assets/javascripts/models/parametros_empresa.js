// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.ParametrosEmpresa = DS.Model.extend({
  imeiEnVentaDetalle: DS.attr('boolean'),
  empresa: DS.belongsTo('empresa',{async: true, defaultValue: null}),
  soportaSucursales: DS.attr('boolean'),
  soportaMultiempresa: DS.attr('boolean'),
  vendedorEnVenta: DS.attr('boolean'),
  tarjetaCreditoEnVenta: DS.attr('boolean'),
  soportaCajaImpresion: DS.attr('boolean'),
  retencioniva: DS.attr('number'),
  soportaUsoInterno: DS.attr('boolean'),
  soportaAjusteInventario: DS.attr('boolean'),
  soportaMultimoneda: DS.attr('boolean'),
  moneda: DS.belongsTo('moneda',{async: true, defaultValue: null}),
  monedaBase: DS.belongsTo('moneda',{async: true, defaultValue: null}),
  recargoPrecioVenta:  DS.attr('boolean'),
  imprimirRemision: DS.attr('boolean'),
  sucursalDefault: DS.belongsTo('sucursal',{async: true, defaultValue: null}),
  soportaCajas: DS.attr('boolean'),
  soportaImpresionFacturaVenta: DS.attr('boolean'),
  soportaParametroCaliente: DS.attr('boolean'),
  soportaGaranteVenta: DS.attr('boolean'),
  soportaProduccion: DS.attr('boolean'),
  soportaImpresionRecibo: DS.attr('boolean'),
  maxDetallesVentas: DS.attr('number', {defaultValue: 30}),
  cierreAutomaticoCaja: DS.attr('boolean'),
  montoAlivio: DS.attr('number')
});
