// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Cotizacion = DS.Model.extend({
  monto: DS.attr('number'),
  fechaHora: DS.attr('isodate', {
      defaultValue: function() {
        return moment().toDate();
      }
  }),
	moneda: DS.belongsTo('moneda', {async:true}),
	monedaBase: DS.belongsTo('moneda', {async:true}),
	usuario: DS.belongsTo('usuario', {async: true})
});
