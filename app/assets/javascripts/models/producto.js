// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Producto = DS.Model.extend({
  codigoBarra: DS.attr('string'),
  descripcion: DS.attr('string'),
  codigoExterno: DS.attr('string'),
  nroInventario: DS.attr('string'),
  nroReferencia: DS.attr('string'),
  nroSerie: DS.attr('string'),
  asignado: DS.attr('string'),
  area: DS.attr('string'),
  modelo: DS.attr('string'),
  responsableMantenimiento: DS.attr('string'),
  anhoFabricacion: DS.attr('string'),
  fechaAdquisicion: DS.attr('isodate', {
      defaultValue: function() {
        return moment().toDate();
      }
  }),
  codigoLocal: DS.attr('string'),
  descripcionExterna: DS.attr('string'),
  presentacion: DS.attr('string'),
  descripcionCodigo: DS.attr('string'),
  descripcionLocal: DS.attr('string'),
  unidad: DS.attr('string'),
  margen: DS.attr('number'),
  precio: DS.attr('number',{defaultValue: 0}),
  precioCompra: DS.attr('number',{defaultValue: 0}),
  iva: DS.attr('number'),
  existencia: DS.attr('number'),
  descuento: DS.attr('number', { defaultValue: 0 }),
  stockMinimo: DS.attr('number', { defaultValue: 0 }),
  precioPromedio: DS.attr('number'),
  pack: DS.attr('boolean', { defaultValue: false }),
  necesitaConsentimientoFirmado: DS.attr('boolean', { defaultValue: false }),
  servicio: DS.attr('boolean', { defaultValue: false }),
  cantidad: DS.attr('number', { defaultValue: 1 }),
  urlFoto: DS.attr('string'),
  activo: DS.attr('boolean', { defaultValue: true }),
  descontinuado: DS.attr('boolean', { defaultValue: true }),
  moneda: DS.belongsTo('moneda', { async: true }),
  lotes: DS.hasMany('lote', { async: true }),
  especialidad: DS.belongsTo('especialidad', { async: true }),
  esProcedimiento: DS.attr('boolean', { defaultValue: false }),
  marca: DS.attr('string'),
  categorias: DS.hasMany('categoria', { async: true }),
  tipoProducto: DS.belongsTo('tipoProducto', { async: true }),
  promocionProducto: DS.hasMany('promocionProducto', { async: true }),
  promocionAplicada: DS.belongsTo('promocion'),
  producto: DS.belongsTo('producto', { async: true }, {inverse: null}),
  productoDetalles: DS.hasMany('productoDetalle',{ async: true, inverse: 'productoPadre'}),

  dineroInvertido: function() {
    return Math.round(this.get('existencia') * this.get('precioPromedio'));
  }.property('existencia', 'precioPromedio'),

});
