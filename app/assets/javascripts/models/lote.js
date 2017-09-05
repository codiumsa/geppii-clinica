// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Lote = DS.Model.extend({
  codigoLote: DS.attr('string'),
  fechaVencimiento: DS.attr('isodate', {
      defaultValue: function() {
        return moment().toDate();
      }
  }),
  producto: DS.belongsTo('producto', {async: true})
});
