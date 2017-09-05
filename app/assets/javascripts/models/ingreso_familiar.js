// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.IngresoFamiliar = DS.Model.extend({
  ingresoMensual: DS.attr('number'),
  vinculoFamiliar: DS.belongsTo('vinculoFamiliar', {embedded: 'always'})
});
