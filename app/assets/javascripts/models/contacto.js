// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Contacto = DS.Model.extend({
  observacion: DS.attr('string'),
  estadoActual: DS.attr('string'),
  compromisoTotal: DS.attr('string'),
  tieneDetalleInKind: DS.attr('boolean'),
  compromisoPagadoInKind: DS.attr('string'),
  compromisoPagado: DS.attr('string'),
  sponsor: DS.belongsTo('sponsor', { async: true }),
  tipoContacto: DS.belongsTo('tipoContacto', { async: true }),
  contactoDetalles: DS.hasMany('contactoDetalle',{ async: true }),
  campanha: DS.belongsTo('campanha', { async: true }),
  fecha: DS.attr('isodate', {
      defaultValue: function() {
        return moment().toDate();
      }
  }),
});
