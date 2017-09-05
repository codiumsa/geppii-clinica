// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.MotivosInventario = DS.Model.extend({
  descripcion: DS.attr('string'),
  codigo: DS.attr('string')
});
