// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Especialidad = DS.Model.extend({
  codigo: DS.attr('string'),
  descripcion: DS.attr('string')
});