// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.SucursalVendedor = DS.Model.extend({
  sucursal: DS.belongsTo('sucursal'),
  vendedor: DS.belongsTo('vendedor')
});
