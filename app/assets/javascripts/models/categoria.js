// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Categoria = DS.Model.extend({
  nombre: DS.attr('string'),
  producto: DS.hasMany('producto'),
  comision: DS.attr('number', {defaultValue: 0})
});
