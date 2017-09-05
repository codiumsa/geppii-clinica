// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.RolesUsuario = DS.Model.extend({
  rol: DS.belongsTo('rol'),
  usuario: DS.belongsTo('usuario')
});
