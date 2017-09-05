// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.ConsultaDetalle = DS.Model.extend({
  consulta: DS.belongsTo('consulta', {async: true}),
  producto: DS.belongsTo('producto', {async: true}),
  cantidad: DS.attr('number'),
  consentimientoFirmado: DS.attr('boolean', { defaultValue: false }),
  referenciaId: DS.attr('string'),
  referenciaNombre: DS.attr('string'),
  estado: DS.attr('string'),
  idFicha: DS.attr('number'),
  fechaInicio: DS.attr('isodate', {
      defaultValue: function() {
        return moment().toDate();
      }
  }),
  fechaFin: DS.attr('isodate', {
      defaultValue: function() {
        return moment().toDate();
      }
  })
});
