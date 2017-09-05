// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.CategoriaCliente = DS.Model.extend({
  nombre: DS.attr('string'),
  descripcion: DS.attr('string'),
  promociones:  DS.hasMany('promocion', {async: true}),
});
