// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.VentaCuota = DS.Model.extend({
  venta: DS.belongsTo('venta', {async:true}),
  nroCuota: DS.attr('number'),
  monto: DS.attr('number'),
  fechaVencimiento: DS.attr('isodate'),
  fechaCobro: DS.attr('isodate', {
      defaultValue: function() {
        return moment().toDate();
      }
  }),
  cancelado: DS.attr('boolean'),
  nroRecibo: DS.attr('string'),
	pendiente: DS.attr('number'),
  estado: DS.attr('string'),
});
