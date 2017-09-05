// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.RecursosRol = DS.Model.extend({
  rol: DS.belongsTo('Bodega.Rol'),
  recurso: DS.belongsTo('Bodega.Recurso')
});
