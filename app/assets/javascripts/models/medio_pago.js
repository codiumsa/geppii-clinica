// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.MedioPago = DS.Model.extend({
  nombre: DS.attr('string'),
  codigo: DS.attr('string'),
  registraPago: DS.attr('boolean'),
  activo: DS.attr('boolean')
});
