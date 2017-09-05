// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.TipoOperacionDetalle = DS.Model.extend({
  tipoOperacion: DS.belongsTo('tipoOperacion', { async: true }),
  descripcion: DS.attr('string'),
  tipoMovimiento: DS.belongsTo('tipoMovimiento', { async: true }),
  cajaDestino: DS.attr('boolean'),
  generaDiferencia: DS.attr('boolean'),
  impactaSaldo: DS.attr('boolean')

});
