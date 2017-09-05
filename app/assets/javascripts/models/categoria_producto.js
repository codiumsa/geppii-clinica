// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.CategoriaProducto = DS.Model.extend({
//  primaryKey: 'categoria',
  categoria: DS.belongsTo('categoria'),
  producto: DS.belongsTo('producto')
});
