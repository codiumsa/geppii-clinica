Bodega.Produccion = DS.Model.extend({
  cantidadProduccion: DS.attr('number', {defaultValue: 1}),
  produccionDetalles: DS.hasMany('produccionDetalle',{ async: true }),
  producto: DS.belongsTo('producto', {async : true}),
  deposito: DS.belongsTo('deposito', {async : true})
});
