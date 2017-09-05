// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.CategoriaClientePromocion = DS.Model.extend({
  categoriaCliente: DS.belongsTo('categoriaCliente'),
  promocion: DS.belongsTo('promocion')
});
