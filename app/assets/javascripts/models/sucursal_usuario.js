// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.SucursalUsuario = DS.Model.extend({
  usuario: DS.belongsTo('usuario'),
  sucursal: DS.belongsTo('sucursal')
});
