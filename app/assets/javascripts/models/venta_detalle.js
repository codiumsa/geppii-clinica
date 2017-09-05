// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.VentaDetalle = DS.Model.extend({
  venta: DS.belongsTo('venta', { async: true }),
  producto: DS.belongsTo('producto'),
  promocion: DS.belongsTo('promocion'),
  cantidad: DS.attr('number', {defaultValue: 1}),
  precio: DS.attr('number', {defaultValue: 0}),
  descuento: DS.attr('number', {defaultValue: 0}),
  imei: DS.attr('string'),
  dirty: DS.attr('boolean', {defaultValue: false}),
  cotizacion: DS.belongsTo('cotizacion', {async:true}),
  montoCotizacion: DS.attr('number'),
  moneda: DS.belongsTo('moneda', {async:true}),
  caliente: DS.attr('boolean', {defaultValue: false}),
  loteId: DS.attr('string'),
  codigoLote: DS.attr('string'),

  subtotal: function() {
    var total = (this.get('precio') * this.get('cantidad')) - this.get('descuento');
    return total < 0 ? 0 : total;
  }.property('cantidad', 'precio', 'descuento'),

  // transcient
  subtotalCotizado: DS.attr('number', {defaultValue: 0}),
  multiplicarCotizacion: DS.attr('boolean')
});
