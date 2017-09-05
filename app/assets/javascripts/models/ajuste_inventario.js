// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.AjusteInventario = DS.Model.extend({
  fecha: DS.attr('isodate', {
      defaultValue: function() {
        return moment().toDate();
      }
  }),
  observacion: DS.attr('string'),
  deposito: DS.belongsTo('deposito', {async: true}),
  usuario: DS.belongsTo('usuario', {async: true}),
  detalle: DS.hasMany('ajusteInventarioDetalle',{ async: true })
});
