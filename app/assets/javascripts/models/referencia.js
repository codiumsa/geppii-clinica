// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Referencia = DS.Model.extend({
  nombre: DS.attr('string'),
  telefono: DS.attr('string'),
  tipoReferencia: DS.attr('string'),
  tipoCuenta: DS.attr('string'),
  activa: DS.attr('boolean')
});
