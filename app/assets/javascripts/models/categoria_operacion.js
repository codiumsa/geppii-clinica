// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.CategoriaOperacion = DS.Model.extend({
  nombre: DS.attr('string'),
  descripcion: DS.attr('string'),
  tipoOperacion: DS.belongsTo('tipoOperacion', { async: true }),
  activo: DS.attr('boolean')
});
