// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Deposito = DS.Model.extend({
  nombre: DS.attr('string'),
  descripcion: DS.attr('string'),
  inventario: DS.hasMany('inventario')
});
