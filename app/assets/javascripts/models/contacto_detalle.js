Bodega.ContactoDetalle = DS.Model.extend({
  contacto: DS.belongsTo('contacto', { async: true }),
  moneda: DS.belongsTo('moneda', { async: true }),
  fecha: DS.attr('isodate', {
        defaultValue: function() {
          return moment().toDate();
        }
  }),
  fechaSiguiente: DS.attr('isodate', {
        defaultValue: function() {
          return moment().toDate();
        }
  }),
  compromiso: DS.attr('number', {defaultValue: 0}),
  comentario: DS.attr('string'),
  estado: DS.attr('string'),
  observacion: DS.attr('string')



});
